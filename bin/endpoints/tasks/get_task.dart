import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../utils/handler_interface.dart';
import '../../utils/permission_level.dart';

class GetTask {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetTaskMongo();
      }
      case "POSTGRESQL":{
        return GetTaskProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetTaskMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final id = req.params['id'];
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(result: 'Id is missing', statusCode: 400).toJson()));
      }
      final taskRaw = await connection.tasks.findOne(where.eq('_id', ObjectId.fromHexString(id)));
      if (taskRaw == null) {
        return Response.notFound(json.encode(ErrorMessage(result: 'Task not found', statusCode: 404).toJson()));
      }
      final task = TaskDBModel.fromJson(taskRaw);
      final linkedTasksRaw = await connection.tasks.find([where.oneFrom('_id', task.linkedTasks)]).toList();
      return Response.ok(json.encode(task.toTaskResponse(linkedTasksRaw.map((user) => ChildTaskResponse.fromJson(user)).toList()).toJson()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching task: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class GetTaskProstgre implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}