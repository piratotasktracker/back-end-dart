import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
import '../repository_interface.dart';

class GetTasksByProjectIdRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
    required bool isBypassed,
  }) async{
    if(params != null){
      final String? userId = params.context["userId"] as String?;
      final List<Map<String, dynamic>> tasksRaw;
      final id = params.params['id'];
      final taskResponses;
      final tasks;
      if(isBypassed){
        tasksRaw = await connection.tasks.find(where.eq("projectId", id), ).toList();
        tasks = tasksRaw.map((task) => TaskDBMongo.fromJson(task)).toList();
        taskResponses = await Future.wait(tasks.map((task) async {
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
      }
      else{
        final Map<String, dynamic>? projectRaw = await connection.projects.findOne(where
          .eq('_id', ObjectId.fromHexString(id??''))
          .oneFrom('teamMembers', [userId])
        );
        if (projectRaw == null) {
          throw NotFoundException();
        }
        tasksRaw = await connection.tasks.find(where.eq("projectId", id), ).toList();
        tasks = tasksRaw.map((task) => TaskDBMongo.fromJson(task)).toList();
        taskResponses = await Future.wait(tasks.map((task) async {
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
      }
      return (true, json.encode(taskResponses));
    }else{
      throw Exception();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection,
    required String credentials,
    Request? params,
    required bool isBypassed,
  }) async {
    if (params != null) {
      final id = params.params['id'];
      if (id == null) {
        throw FormatException("Project ID is required.");
      }

      final String? userId = params.context["userId"] as String?;
      String query = '''
        SELECT t.*, 
              u1.id AS created_by_id, u1.full_name AS created_by_full_name, u1.email AS created_by_email, u1.password AS created_by_password, u1.avatar AS created_by_avatar, u1.role AS created_by_role,
              u2.id AS assignee_id, u2.full_name AS assignee_full_name, u2.email AS assignee_email, u2.password AS assignee_password, u2.avatar AS assignee_avatar, u2.role AS assignee_role
        FROM tasks t
        LEFT JOIN users u1 ON t.created_by_id = u1.id
        LEFT JOIN users u2 ON t.assignee_id = u2.id
        WHERE t.project_id = @projectId
      ''';
      query += ' AND EXISTS (SELECT 1 FROM project_team_members ptm WHERE ptm.project_id = t.project_id AND ptm.user_id = @userId)';

      final result = await connection.db.query(query, substitutionValues: {
        'projectId': int.parse(id),
        'userId': userId != null ? int.parse(userId) : null,
      });

      if (result.isEmpty) {
        throw NotFoundException("No tasks found for project ID $id.");
      }

      final taskResponses = result.map((row) {
        final taskData = row.toColumnMap();

        final createdByResponse = UserDBPostgre(
          id: taskData['created_by_id'],
          fullName: taskData['created_by_full_name'],
          email: taskData['created_by_email'],
          avatar: taskData['created_by_avatar'],
          roleId: taskData['created_by_roleId'],
          password: taskData['created_by_password'],
        ).toUserResponse();

        final assigneeResponse = taskData['assignee_id'] != null
            ? UserDBPostgre(
                id: taskData['assignee_id'],
                fullName: taskData['assignee_full_name'],
                email: taskData['assignee_email'],
                avatar: taskData['assignee_avatar'],
                roleId: taskData['assignee_roleId'],
                password: taskData['assignee_password'],
              ).toUserResponse()
            : null;

        return TaskDBPostgre(
          id: taskData['id'],
          name: taskData['name'],
          description: taskData['description'],
          projectId: taskData['project_id'].toString(),
          createdById: taskData['created_by_id'].toString(),
          assigneeId: taskData['assignee_id']?.toString(),
          createdAt: taskData['created_at'].toString(),
          updatedAt: taskData['updated_at'].toString(),
        ).toTaskResponse(
          newLinkedTasks: [],
          assignee: assigneeResponse,
          createdBy: createdByResponse,
        ).toJson();
      }).toList();

      return (true, json.encode(taskResponses));
    } else {
      throw FormatException("Request parameters are missing.");
    }
  }


}