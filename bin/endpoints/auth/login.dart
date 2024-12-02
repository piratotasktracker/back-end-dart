import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/auth/login_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/result_models.dart';
import '../../models/login_model.dart';
import '../../db_connection.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';
import '../../validators/auth/login_validator.dart';
import '../../validators/validator_interface.dart';

class Login implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final credentials = LoginModel.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(credentials);
      if(validation.$1){
        final result = await repository.interact(connection: connection, credentials: credentials);
        if(result.$1){
          return Response.ok(json.encode({'token': result.$2}));
        }else {
          return Response.notFound(json.encode(ErrorMessage(result: result.$2, statusCode: 404).toJson()));
        }
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error login: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
  
  @override
  PermissionLevel get permissionLevel => PermissionLevel.unknown;
  
  @override
  IValidator validator = LoginValidator();

  @override
  IRepository<DBConnection, LoginModel> get repository => LoginRepository();

}