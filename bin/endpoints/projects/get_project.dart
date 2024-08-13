import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/project_model.dart';
import '../../models/result_models.dart';
import '../../mongo_connection.dart';
import '../../utils/handler_interface.dart';

class GetProject {
  static IHandler call(){
    final String dbType = (DotEnv()..load()).getOrElse('DB_TYPE', () => '');
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
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(message: 'Id is missing', statusCode: 400).toJson()));
      }
      final projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id)));
      if (projectRaw == null) {
        return Response.notFound(json.encode(ErrorMessage(message: 'Project not found', statusCode: 404).toJson()));
      }
      var user = ProjectDBModel.fromJson(projectRaw);
      return Response.ok(json.encode(user.toProjectResponse().toJson()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error fetching project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
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
}