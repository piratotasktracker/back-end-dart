import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/projects/create_project_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/project_model.dart';
import '../../db_connection.dart';
import '../../validators/projects/project_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_check_mixin.dart';
import '../../utils/permission_level.dart';

class CreateProject with PermissionCheckMixin implements IPostHandler {
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try {
      final bool isBypassed = await checkPermissions(permissionsList: permissionsList, connection: connection, params: req);
      final credentials = ProjectRequest.fromJson(json.decode(await req.readAsString()));
      validator.validate(credentials);
      final result = await repository.interact(connection: connection, credentials: credentials, params: req, isBypassed: isBypassed);
      return Response.ok(result.$2);
    } catch(e){
      if(e is Exception){
        rethrow;
      }else{
        print(e);
        throw Exception();
      }
    }
  }

  @override
  List<ActionPermission> get permissionsList => [ActionPermission.canCreateProjects];

  @override
  IValidator validator = ProjectValidator();

  @override
  IRepository<DBConnection, ProjectRequest> get repository => CreateProjectRepository();
  
  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
  
}