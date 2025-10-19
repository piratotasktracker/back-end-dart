import 'package:shelf/shelf.dart';

import '../../data/repository_interface.dart';
import '../../data/users/get_me_repository.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class GetMe implements IHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final String userId = req.context["userId"] as String;
      final result = await repository.interact(connection: connection, credentials: userId, params: req, isBypassed: false);
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
  IRepository<DBConnection, String> get repository => GetMeRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

}