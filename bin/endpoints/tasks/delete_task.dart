import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/repository_interface.dart';
import '../../data/tasks/delete_task_repository.dart';
import '../../db_connection.dart';
import '../../utils/error_handler.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class DeleteTask with PermissionCheckMixin implements IHandler{

  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      checkPermission(req: req, permissionLevel: permissionLevel);
      final id = req.params['id'];
      if (id == null) {
        throw NotFoundException();
      }
      final result = await repository.interact(connection: connection, credentials: id, params: req);
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
  IRepository<DBConnection, String> get repository => DeleteTaskRepository();

}