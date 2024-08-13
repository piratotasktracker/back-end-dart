import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/result_models.dart';
import '../../models/user_db_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../utils/handler_interface.dart';

class GetUser {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return GetUserMongo();
      }
      case "POSTGRESQL":{
        return GetUserProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class GetUserMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final id = req.params['id'];
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(message: 'Id is missing', statusCode: 400).toJson()));
      }
      final userRaw = await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(id)));
      if (userRaw == null) {
        return Response.notFound(json.encode(ErrorMessage(message: 'User not found', statusCode: 404).toJson()));
      }
      var user = UserDBModel.fromJson(userRaw);
      return Response.ok(json.encode(user.toUserDTO().toJson()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error fetching user: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
}

class GetUserProstgre implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }
}