import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/projects/create_project_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/result_models.dart';
import '../../models/project_model.dart';
import '../../db_connection.dart';
import '../../validators/projects/project_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class CreateProject implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final credentials = ProjectRequest.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(credentials);
      if(validation.$1){
        final result = await repository.interact(connection: connection, credentials: credentials);
        if(result.$1){
          return Response.ok(json.encode(SuccessMessage(result: result.$2, statusCode: 200).toJson()));
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
  PermissionLevel get permissionLevel => PermissionLevel.administrator;

  @override
  IValidator validator = ProjectValidator();

  @override
  IRepository<DBConnection, ProjectRequest> get repository => throw CreateProjectRepository();
  
}