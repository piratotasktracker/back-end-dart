import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/user_db_model.dart';
import '../../mongo_connection.dart';
import '../../utils/handler_interface.dart';

class GetUsers {
  static IHandler call(){
    final String dbType = (DotEnv()..load()).getOrElse('DB_TYPE', () => '');
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
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final usersRaw = await connection.users.find().toList();
      var users = usersRaw.map((user) => UserDBModel.fromJson(user)).toList();
      return Response.ok(json.encode(users.map((user) => user.toUserDTO().toJson()).toList()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error fetching users: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
}

class GetUsersProstgre implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }
}