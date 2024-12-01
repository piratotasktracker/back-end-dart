import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/project_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../validators/projects/project_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class CreateProject {
  static IPostHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return CreateProjectMongo();
      }
      case "POSTGRESQL":{
        return CreateProjectProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class CreateProjectMongo implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final credentials = ProjectRequest.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(credentials);
      if(validation.$1){
        String now = DateTime.now().toIso8601String();
        await connection.projects.insertOne(
          credentials.dbCreate(createdAt: now, updatedAt: now)
        );
        return Response.ok(json.encode(SuccessMessage(result: 'Project ${credentials.name} created successfully', statusCode: 200).toJson()));
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error creating project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.administrator;

  @override
  IValidator validator = ProjectValidator();
  
}

class CreateProjectProstgre implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.administrator;

  @override
  IValidator validator = ProjectValidator();

}