import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/roles/create_role_repository.dart';
import '../../db_connection.dart';
import '../../models/role_model.dart';
import '../../validators/roles/role_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_check_mixin.dart';
import '../../utils/permission_level.dart';

class CreateRole with PermissionCheckMixin implements IPostHandler {
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try {
      final bool isBypassed = await checkPermissions(permissionsList: permissionsList, connection: connection, params: req);
      final credentials = RoleRequest.fromJson(json.decode(await req.readAsString()));
      validator.validate(credentials);
      final result = await repository.interact(connection: connection, credentials: credentials, params: req, isBypassed: isBypassed);
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
  List<ActionPermission> get permissionsList => [ActionPermission.canCreateRoles];

  @override
  IValidator validator = RoleValidator();

  @override
  IRepository<DBConnection, RoleRequest> get repository => CreateRoleRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
  
}