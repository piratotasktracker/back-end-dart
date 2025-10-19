

import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/users/get_users_repository.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_check_mixin.dart';
import '../../utils/permission_level.dart';

class GetUsers with PermissionCheckMixin implements IHandler{
  
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final bool isBypassed = await checkPermissions(permissionsList: permissionsList, connection: connection, params: req);
      final result = await repository.interact(connection: connection, credentials: null, params: req, isBypassed: isBypassed);
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
  List<ActionPermission> get permissionsList => [];

  @override
  IRepository<DBConnection, void> get repository => GetUsersRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

}