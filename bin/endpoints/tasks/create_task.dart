import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/tasks/create_task_repository.dart';
import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../../db_connection.dart';
import '../../validators/trasks/task_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class CreateTask implements IPostHandler{

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
        final result = await repository.interact(connection: connection, credentials: credentials, params: req);
        if(result.$1){
        return Response.ok(result.$2);
      }else {
        return Response(400, body: json.encode(ErrorMessage(result: result.$2, statusCode: 400).toJson()));
      }
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

  @override
  IRepository<DBConnection, TaskRequest> get repository => CreateTaskRepository();

}