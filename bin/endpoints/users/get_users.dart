import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/user_db_model.dart';
import '../../db_connection.dart';
import '../../utils/environment.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetUsers {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetUsersMongo();
      }
      case "POSTGRESQL":{
        return GetUsersProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetUsersMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final usersRaw = await connection.users.find().toList();
      final users = usersRaw.map((user) => UserDBModel.fromJson(user)).toList();
      return Response.ok(json.encode(users.map((user) => user.toUserResponse().toJson()).toList()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching users: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class GetUsersProstgre implements IHandler{
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