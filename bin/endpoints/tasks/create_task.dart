import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/tasks/create_task_repository.dart';
import '../../models/task_model.dart';
import '../../db_connection.dart';
import '../../validators/trasks/task_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class CreateTask with PermissionCheckMixin implements IPostHandler{

  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      checkPermission(req: req, permissionLevel: permissionLevel);
      final credentials = TaskRequest.fromJson(json.decode(await req.readAsString()));
      validator.validate(credentials);
      final result = await repository.interact(connection: connection, credentials: credentials, params: req);
      return Response.ok(result.$2);
    } catch(e){
      if(e is Exception){
        rethrow;
      }else{
        throw Exception();
      }
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