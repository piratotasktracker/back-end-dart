import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/repository_interface.dart';
import '../../data/tasks/update_task_repository.dart';
import '../../models/task_model.dart';
import '../../db_connection.dart';
import '../../utils/error_handler.dart';
import '../../validators/trasks/task_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_check_mixin.dart';
import '../../utils/permission_level.dart';

class UpdateTask with PermissionCheckMixin implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final bool isBypassed = await checkPermissions(permissionsList: permissionsList, connection: connection, params: req);
      final id = req.params['id'];
      if (id == null) {
        throw NotFoundException();
      }
      final credentials = TaskRequest.fromJson(json.decode(await req.readAsString()));
      validator.validate(credentials);
      final result = await repository.interact(connection: connection, credentials: credentials, params: req, isBypassed: isBypassed);
      return Response.ok(result.$2);
    } catch(e){
      if(e is Exception){
        rethrow;
      } else if(e is Error){
        throw Exception(e.stackTrace);
      } else{
        throw Exception();
      }
    }
  }

  @override
  List<ActionPermission> get permissionsList => [ActionPermission.canUpdateTasks];

  @override
  IValidator validator = TaskValidator();

  @override
  IRepository<DBConnection, TaskRequest> get repository => UpdateTaskRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

}