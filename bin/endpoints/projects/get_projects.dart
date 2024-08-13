import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../models/project_model.dart';
import '../../models/result_models.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../utils/handler_interface.dart';

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
      final projectsRaw = await connection.projects.find().toList();
      var users = projectsRaw.map((user) => ProjectDBModel.fromJson(user)).toList();
      return Response.ok(json.encode(users.map((user) => user.toProjectResponse().toJson()).toList()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error fetching projects: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
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
}