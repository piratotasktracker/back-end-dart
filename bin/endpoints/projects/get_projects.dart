import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/project_model.dart';
import '../../models/result_models.dart';
import '../../models/user_db_model.dart';
import '../../db_connection.dart';
import '../../utils/environment.dart';
import '../handler_interface.dart';
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
  Future<Response> rootHandler(Request req, DBConnection connection) async{
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
      final projects = projectsRaw.map((project) => ProjectDBModel.fromJson(project)).toList();
      final List<ProjectResponse> result = [];
      for(var item in projects){
        final teamMembersRaw = await connection.users.find(where.oneFrom('_id', item.teamMembers.map((e) => ObjectId.fromHexString(e)).toList())).toList();
        result.add(item.toProjectResponse(teamMembersRaw.map((user) => UserDBModel.fromJson(user).toUserResponse()).toList()));
      }
      return Response.ok(json.encode(result));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching projects: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class GetProjectsProstgre implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required DBConnection connection}) {
    throw UnimplementedError();
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}