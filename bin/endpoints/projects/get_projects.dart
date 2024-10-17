import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/project_model.dart';
import '../../models/result_models.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../utils/handler_interface.dart';
import '../../utils/permission_level.dart';

class GetProjects {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetProjectsMongo();
      }
      case "POSTGRESQL":{
        return GetProjectsProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetProjectsMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final List<Map<String, dynamic>> projectsRaw;
      if(userPermission.value > 2){
        projectsRaw = await connection.projects.find().toList();
      }else{
        projectsRaw = await connection.projects.find(where.eq("teamMembers", userId)).toList();
      }
      final projects = projectsRaw.map((user) => ProjectDBModel.fromJson(user)).toList();
      return Response.ok(json.encode(projects.map((user) => user.toProjectResponse([]).toJson()).toList()));
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

class GetProjectsProstgre implements IHandler{
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