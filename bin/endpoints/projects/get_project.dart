import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/project_model.dart';
import '../../models/result_models.dart';
import '../../models/user_db_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetProject {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetProjectMongo();
      }
      case "POSTGRESQL":{
        return GetProjectProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetProjectMongo implements IHandler{
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
      final Map<String, dynamic>? projectRaw;
      if(userPermission.value > 2){
        projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id)));
      }else{
        projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id)).eq('teamMembers', userId)); 
      }
      if (projectRaw == null) {
        return Response.notFound(json.encode(ErrorMessage(result: 'Project not found', statusCode: 404).toJson()));
      }
      final ProjectDBModel project = ProjectDBModel.fromJson(projectRaw);
      final teamMembersRaw = await connection.users.find(where.oneFrom('_id', project.teamMembers.map((e) => ObjectId.fromHexString(e)).toList())).toList();
      return Response.ok(json.encode(project.toProjectResponse(teamMembersRaw.map((user) => UserDBModel.fromJson(user).toUserResponse()).toList()).toJson()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class GetProjectProstgre implements IHandler{
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