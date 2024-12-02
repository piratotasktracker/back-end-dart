import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/user_db_model.dart';
import '../../db_connection.dart';
import '../../utils/environment.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetMe {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetMeMongo();
      }
      case "POSTGRESQL":{
        return GetMeProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetMeMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final userRaw = await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(userId)));
      if (userRaw == null) {
        return Response.notFound(json.encode(ErrorMessage(result: 'User not found', statusCode: 404).toJson()));
      }
      final user = UserDBModel.fromJson(userRaw);
      return Response.ok(json.encode(user.toUserResponse().toJson()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching user: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class GetMeProstgre implements IHandler{
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