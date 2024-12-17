import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetMyTasksRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    if(params != null){
      final String? userId = params.context["userId"] as String?;
      final projectsRaw = await connection.tasks.find(where.eq("assigneeId", userId).or(where.eq("createdById", userId))).toList();
      final tasks = projectsRaw.map((task) => TaskDBMongo.fromJson(task)).toList();
      final taskResponses = await Future.wait(tasks.map((task) async {
      final assigneeResponse = task.assigneeId != null
        ? UserDBMongo.fromJson((await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(task.assigneeId!))))!).toUserResponse()
        : null;
      final createdByResponse = UserDBMongo.fromJson((await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(task.createdById))))!).toUserResponse();
      return task.toTaskResponse(
        newLinkedTasks: [],
        assignee: assigneeResponse,
        createdBy: createdByResponse,
      ).toJson();
    }).toList());
    return (true, json.encode(taskResponses));
    }else{
      throw Exception();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required void credentials, 
    Request? params,
  }) async {
    try {
      final String? userId = params?.context["userId"] as String?;
      if (userId == null) throw Exception("User ID not provided");

      final PermissionLevel userPermission = PermissionLevel.fromInt(params?.context["permissionLevel"] as int? ?? 0);

      String query = '''
        SELECT t.*, 
               u_assignee.id AS assignee_id, u_assignee.full_name AS assignee_name, u_assignee.email AS assignee_email, u_assignee.role AS assignee_role, u_assignee.avatar AS assignee_avatar,
               u_creator.id AS creator_id, u_creator.full_name AS creator_name, u_creator.email AS creator_email, u_creator.role AS creator_role, u_creator.avatar AS creator_avatar
        FROM tasks t
        LEFT JOIN users u_assignee ON t.assignee_id = u_assignee.id
        LEFT JOIN users u_creator ON t.created_by_id = u_creator.id
        WHERE t.assignee_id = @userId OR t.created_by_id = @userId
      ''';

      if (userPermission.value <= 2) {
        query += ' AND (@userId = ANY(t.team_members))';
      }

      final result = await connection.db.query(query, substitutionValues: {
        'userId': userId,
      });

      if (result.isEmpty) throw Exception("No tasks found for the user");

      final tasks = result.map((row) {
        final taskData = row.toColumnMap();
        final task = TaskDBPostgre(
          id: taskData['id'],
          name: taskData['name'],
          description: taskData['description'],
          projectId: taskData['project_id'].toString(),
          createdById: taskData['created_by_id'].toString(),
          assigneeId: taskData['assignee_id']?.toString(),
          createdAt: (taskData['created_at'] as DateTime).toIso8601String(),
          updatedAt: (taskData['updated_at'] as DateTime).toIso8601String(),
        );

        final assigneeResponse = task.assigneeId != null
            ? UserDBPostgre(
                id: taskData['assignee_id'],
                fullName: taskData['assignee_name'],
                avatar: taskData['assignee_avatar'],
                email: taskData['assignee_email'],
                role: PermissionLevel.fromInt(taskData['assignee_role']),
                password: null,
              ).toUserResponse()
            : null;

        final createdByResponse = UserDBPostgre(
          id: taskData['creator_id'],
          fullName: taskData['creator_name'],
          avatar: taskData['creator_avatar'],
          email: taskData['creator_email'],
          role: PermissionLevel.fromInt(taskData['creator_role']),
          password: null,
        ).toUserResponse();

        return task.toTaskResponse(
          newLinkedTasks: [],
          assignee: assigneeResponse,
          createdBy: createdByResponse,
        ).toJson();
      }).toList();

      return (true, json.encode(tasks));
    } catch (e) {
      return (false, json.encode({'error': e.toString()}));
    }
  }

}