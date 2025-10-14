import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/roles/get_roles_repository.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetRoles implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final result = await repository.interact(connection: connection, credentials: null, params: req, isBypassed: true);
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
  IRepository<DBConnection, void> get repository => GetRolesRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

}