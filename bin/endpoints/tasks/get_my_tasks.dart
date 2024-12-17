import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/tasks/get_my_tasks_repository.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetMyTasks with PermissionCheckMixin implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      checkPermission(req: req, permissionLevel: permissionLevel);
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
  IRepository<DBConnection, void> get repository => GetMyTasksRepository();

}