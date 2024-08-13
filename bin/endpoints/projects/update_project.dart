import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/result_models.dart';
import '../../models/project_model.dart';
import '../../mongo_connection.dart';
import '../../utils/handler_interface.dart';

class UpdateProject {
  static IPostHandler call(){
    final String dbType = (DotEnv()..load()).getOrElse('DB_TYPE', () => '');
    switch (dbType){
      case "MONGODB":{
        return UpdateProjectMongo();
      }
      case "POSTGRESQL":{
        return UpdateProjectProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class UpdateProjectMongo implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final id = req.params['id'];
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(message: 'Id is missing', statusCode: 400).toJson()));
      }
      final credentials = DBProjectModel.fromJson(json.decode(await req.readAsString()));
      final validation = validate(credentials);
      if(validation.$1){
        final String now = DateTime.now().toIso8601String();
        var modifier = modify;
        credentials.dbUpdate(updatedAt: now).forEach((key, value) {
          modifier = modifier.set(key, value);
        });
        print(modifier.map);
        await connection.projects.updateOne(
          where.eq('_id', ObjectId.fromHexString(id)),
          modifier,
        );
        return Response.ok(json.encode(SuccessMessage(result: 'Project ${credentials.name} updated successfully', statusCode: 200).toJson()));
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error updating project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  (bool, ErrorMessage?) validate(data) {
    if (data is DBProjectModel){
      Map<String, dynamic> messageMap = {};
      if(data.name.isEmpty){
        messageMap["email"] = "Can not be empty or has non E-mail stucture";
      }
      return messageMap.isEmpty ? (true, null) : (false, ErrorMessage(message: messageMap.toString(), statusCode: 400));
    }else{
      return (false, ErrorMessage(message: "Bad request", statusCode: 400));
    }
  }
}

class UpdateProjectProstgre implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }
  
  @override
  (bool, ErrorMessage?) validate(data) {
    // TODO: implement validate
    throw UnimplementedError();
  }
}