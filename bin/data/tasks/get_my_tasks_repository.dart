import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
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
      final tasks = projectsRaw.map((task) => TaskDBModel.fromJson(task)).toList();
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
  }) {
    throw UnimplementedError();
  }

}