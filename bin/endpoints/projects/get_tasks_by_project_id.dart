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

class GetTasksByProjectId {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetTasksByProjectIdMongo();
      }
      case "POSTGRESQL":{
        return GetTasksByProjectIdProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetTasksByProjectIdMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final id = req.params['id'];
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(result: 'Id is missing', statusCode: 400).toJson()));
      }
      final List<Map<String, dynamic>> tasksRaw;
      if(userPermission.value > 2){
        tasksRaw = await connection.tasks.find(where.eq("projectId", id)).toList();
      }else{
        tasksRaw = await connection.tasks.find(where.eq("projectId", id).eq("teamMembers", userId)).toList();
      }
      final projects = tasksRaw.map((user) => TaskDBModel.fromJson(user)).toList();
      return Response.ok(json.encode(projects.map((user) => user.toTaskResponse([]).toJson()).toList()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching projects: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class GetTasksByProjectIdProstgre implements IHandler{
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