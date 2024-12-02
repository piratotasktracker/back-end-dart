import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/projects/delete_project_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/result_models.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class DeleteProject implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final id = req.params['id'];
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(result: 'Id is missing', statusCode: 400).toJson()));
      }
      final result = await repository.interact(connection: connection, credentials: id);
      if(result.$1){
        return Response.ok(json.encode(SuccessMessage(result: result.$2, statusCode: 200).toJson()));
      }else{
        return Response(400, body: json.encode(ErrorMessage(result: result.$2, statusCode: 400).toJson()));
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error deleting project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.administrator;

  @override
  IRepository<DBConnection, String> get repository => DeleteProjectRepository();
}