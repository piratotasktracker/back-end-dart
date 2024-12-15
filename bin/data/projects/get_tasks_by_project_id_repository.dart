import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetTasksByProjectIdRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    if(params != null){
      final List<Map<String, dynamic>> tasksRaw;
      final id = params.params['id'];
      final String? userId = params.context["userId"] as String?;
      final PermissionLevel userPermission = PermissionLevel.fromInt(params.context["permissionLevel"] as int? ?? 0);
      if(userPermission.value > 2){
        tasksRaw = await connection.tasks.find(where.eq("projectId", id)).toList();
      }else{
        tasksRaw = await connection.tasks.find(where.eq("projectId", id).eq("teamMembers", userId)).toList();
      }
      final tasks = tasksRaw.map((task) => TaskDBModel.fromJson(task)).toList();
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
    required String credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}