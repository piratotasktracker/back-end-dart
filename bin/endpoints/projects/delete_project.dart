import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/result_models.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../utils/handler_interface.dart';

class DeleteProject {
  static IHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return DeleteProjectMongo();
      }
      case "POSTGRESQL":{
        return DeleteProjectProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class DeleteProjectMongo implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final id = req.params['id'];
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(message: 'Id is missing', statusCode: 400).toJson()));
      }
      await connection.projects.deleteOne(where.eq('_id', ObjectId.fromHexString(id)));
      return Response.ok(json.encode(SuccessMessage(result: 'Project deleted successfully', statusCode: 200).toJson()));
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error deleting project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
}

class DeleteProjectProstgre implements IHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }
}