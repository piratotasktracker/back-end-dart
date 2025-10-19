import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/auth/sign_up_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/sign_up_model.dart';
import '../../db_connection.dart';
import '../../validators/auth/sign_in_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_check_mixin.dart';
import '../../utils/permission_level.dart';

class SignUp with PermissionCheckMixin implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try{
      final signUpRequest = SignUpModel.fromJson(json.decode(await req.readAsString()));
      validator.validate(signUpRequest);
      final result = await repository.interact(connection: connection, credentials: signUpRequest, params: req, isBypassed: false);
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
  IValidator validator = SignUpValidator();

  @override
  IRepository<DBConnection, SignUpModel> get repository => SignUpRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

}