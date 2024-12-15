import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
import '../repository_interface.dart';


//TODO: apply permissions
class GetTasksRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    final tasksRaw = await connection.tasks.find().toList();
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