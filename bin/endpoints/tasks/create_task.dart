import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../../db_connection.dart';
import '../../utils/environment.dart';
import '../../validators/trasks/task_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class CreateTask {
  static IPostHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return CreateTaskMongo();
      }
      case "POSTGRESQL":{
        return CreateTaskProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class CreateTaskMongo implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final credentials = TaskRequest.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(credentials);
      if(validation.$1){
        String now = DateTime.now().toIso8601String();
        await connection.tasks.insertOne(
          credentials.dbCreate(createdAt: now, updatedAt: now)
        );
        return Response.ok(json.encode(SuccessMessage(result: 'Task ${credentials.name} created successfully', statusCode: 200).toJson()));
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error creating project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.manager;
  
  @override
  IValidator validator = TaskValidator();

}

class CreateTaskProstgre implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required DBConnection connection}) {
    throw UnimplementedError();
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.manager;

  @override
  IValidator validator = TaskValidator();

}