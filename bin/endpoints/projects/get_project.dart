import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/projects/get_project_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/result_models.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetProject implements IHandler{
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
      final result = await repository.interact(connection: connection, credentials: null, params: req);
      if(result.$1){
        return Response.ok(result.$2);
      }else{
        return Response(404, body: json.encode(ErrorMessage(result: result.$2, statusCode: 404).toJson()));
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;

  @override
  IRepository<DBConnection, void> get repository => GetProjectRepository();

}