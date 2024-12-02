import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/auth/sign_up_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/result_models.dart';
import '../../models/sign_up_model.dart';
import '../../db_connection.dart';
import '../../validators/auth/sign_in_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class SignUp implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final signUpRequest = SignUpModel.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(signUpRequest);
      if(validation.$1){
        final result = await repository.interact(connection: connection, credentials: signUpRequest, params: req);
        if(result.$1){
          return Response.ok(result.$2);
        }else {
          return Response(400, body: json.encode(ErrorMessage(result: result.$2, statusCode: 400).toJson()));
        }
      }
      return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: e.toString(), statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.unknown;

  @override
  IValidator validator = SignUpValidator();

  @override
  IRepository<DBConnection, SignUpModel> get repository => SignUpRepository();

}