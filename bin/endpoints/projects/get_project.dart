import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/projects/get_project_repository.dart';
import '../../data/repository_interface.dart';
import '../../db_connection.dart';
import '../../utils/error_handler.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetProject with PermissionCheckMixin implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final id = req.params['id'];
      checkPermission(req: req, permissionLevel: permissionLevel);
      if (id == null) {
        throw NotFoundException();  
      }
      final result = await repository.interact(connection: connection, credentials: null, params: req);
      return Response.ok(result.$2);
    } catch(e){
      print(e.toString());
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
  PermissionLevel get permissionLevel => PermissionLevel.executor;

  @override
  IRepository<DBConnection, void> get repository => GetProjectRepository();

}