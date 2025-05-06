import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../data/projects/get_tasks_by_project_id_repository.dart';
import '../../data/repository_interface.dart';
import '../../db_connection.dart';
import '../../utils/error_handler.dart';
import '../handler_interface.dart';
import '../../utils/permission_check_mixin.dart';
import '../../utils/permission_level.dart';

class GetTasksByProjectId with PermissionCheckMixin implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final bool isBypassed = await checkPermissions(permissionsList: permissionsList, connection: connection, params: req);
      final id = req.params['id'];
      if (id == null) {
        throw NotFoundException();
      }
      final result = await repository.interact(connection: connection, credentials: id, params: req, isBypassed: isBypassed);
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
  List<ActionPermission> get permissionsList => [ActionPermission.canGetTasks, ActionPermission.canGetProjects];

  @override
  IRepository<DBConnection, String> get repository => GetTasksByProjectIdRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
}