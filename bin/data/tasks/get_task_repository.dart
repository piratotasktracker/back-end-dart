import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
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
      final task = TaskDBModel.fromJson(taskRaw);
      final linkedTasksRaw = await connection.tasks.find(where.oneFrom('_id', task.linkedTasks)).toList();
      final assigneeResponse = task.assigneeId != null
        ? UserDBModel.fromJson((await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(task.assigneeId!))))!).toUserResponse()
        : null;
      final createdByResponse = UserDBModel.fromJson(
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
  }) {
    throw UnimplementedError();
  }

}