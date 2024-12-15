import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetTaskRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    if(params != null){
      final taskRaw = await connection.tasks.findOne(where.eq('_id', ObjectId.fromHexString(credentials)));
      if (taskRaw == null) {
        throw NotFoundException();
      }
      final task = TaskDBMongo.fromJson(taskRaw);
      final linkedTasksRaw = await connection.tasks.find(where.oneFrom('_id', task.linkedTasks)).toList();
      final assigneeResponse = task.assigneeId != null
        ? UserDBMongo.fromJson((await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(task.assigneeId!))))!).toUserResponse()
        : null;
      final createdByResponse = UserDBMongo.fromJson(
        (await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(task.createdById))))!).toUserResponse();
      final taskResponse = task.toTaskResponse(
        newLinkedTasks: linkedTasksRaw.map((task) => ChildTaskResponse.fromJson(task)).toList(),
        assignee: assigneeResponse,
        createdBy: createdByResponse,
      );
      return (true, json.encode(taskResponse.toJson()));
    }else{
      throw NotFoundException();
    }
  }
  
    @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection,
    required String credentials,
    Request? params,
  }) async {
    try {
      final String? id = params?.params['id'];
      if (id == null) throw NotFoundException();

      final String? userId = params?.context["userId"] as String?;
      final PermissionLevel userPermission = PermissionLevel.fromInt(params?.context["permissionLevel"] as int? ?? 0);

      String query = '''
        SELECT t.*, 
               u_assignee.id AS assignee_id, u_assignee.full_name AS assignee_name, u_assignee.email AS assignee_email, u_assignee.role AS assignee_role, u_assignee.avatar AS assignee_avatar,
               u_creator.id AS creator_id, u_creator.full_name AS creator_name, u_creator.email AS creator_email, u_creator.role AS creator_role, u_creator.avatar AS creator_avatar
        FROM tasks t
        LEFT JOIN users u_assignee ON t.assignee_id = u_assignee.id
        LEFT JOIN users u_creator ON t.created_by_id = u_creator.id
        WHERE t.id = @id
      ''';

      if (userPermission.value <= 2) {
        query += ' AND (t.created_by = @userId OR @userId = ANY(t.team_members))';
      }

      final result = await connection.db.query(query, substitutionValues: {
        'id': id,
        'userId': userId,
      });

      if (result.isEmpty) throw NotFoundException();

      final taskData = result.first.toColumnMap();
      final task = TaskDBPostgre(
        id: taskData['id'],
        name: taskData['name'],
        description: taskData['description'],
        projectId: taskData['project_id'].toString(),
        createdById: taskData['created_by_id'].toString(),
        assigneeId: taskData['assignee_id'].toString(),
        createdAt: (taskData['created_at'] as DateTime).toIso8601String(),
        updatedAt: (taskData['updated_at'] as DateTime).toIso8601String(),
      );
      final linkedTasksQuery = '''
        SELECT t.*
        FROM task_linked_tasks tl
        JOIN tasks t ON t.id = tl.linked_task_id
        WHERE tl.task_id = @taskId
      ''';
      
      final linkedTasksResult = await connection.db.query(linkedTasksQuery, substitutionValues: {
        'taskId': id,
      });
      final linkedTasks = linkedTasksResult.map((row) {
        return ChildTaskResponse(
          id: row.toColumnMap()['id'].toString(),
          name: row.toColumnMap()['name'],
          description: row.toColumnMap()['description'],
          projectId: row.toColumnMap()['project_id'].toString(),
          createdById: row.toColumnMap()['created_by_id'].toString(),
          assigneeId: row.toColumnMap()['assignee_id'].toString(),
          createdAt: (row.toColumnMap()['created_at'] as DateTime).toIso8601String(),
          updatedAt: (row.toColumnMap()['updated_at'] as DateTime).toIso8601String(),
        );
      }).toList();

      final assigneeData = result.firstWhere((row) => row.toColumnMap().containsKey('assignee_id'));
      final createdByData = result.firstWhere((row) => row.toColumnMap().containsKey('creator_id'));

      final assigneeResponse = UserDBPostgre(
        id: assigneeData.toColumnMap()['assignee_id'],
        fullName: assigneeData.toColumnMap()['assignee_name'],
        avatar: assigneeData.toColumnMap()['assignee_avatar'],
        email: assigneeData.toColumnMap()['assignee_email'],
        role: PermissionLevel.fromInt(assigneeData.toColumnMap()['assignee_role']),
        password: null,
      ).toUserResponse();
      final createdByResponse = UserDBPostgre(
        id: createdByData.toColumnMap()['creator_id'],
        fullName: createdByData.toColumnMap()['creator_name'],
        avatar: createdByData.toColumnMap()['creator_avatar'],
        email: createdByData.toColumnMap()['creator_email'],
        role: PermissionLevel.fromInt(createdByData.toColumnMap()['creator_role']),
        password: null,
      ).toUserResponse();

      final taskResponse = task.toTaskResponse(
        newLinkedTasks: linkedTasks,
        assignee: assigneeResponse,
        createdBy: createdByResponse,
      );

      return (true, json.encode(taskResponse.toJson()));
    } catch (e) {
      throw NotFoundException("Task not found or error occurred: $e");
    }
  }


}