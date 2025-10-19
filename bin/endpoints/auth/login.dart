import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../data/auth/login_repository.dart';
import '../../data/repository_interface.dart';
import '../../models/login_model.dart';
import '../../db_connection.dart';
import '../../utils/permission_level.dart';
import '../handler_interface.dart';
import '../../validators/auth/login_validator.dart';
import '../../validators/validator_interface.dart';

class Login implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, DBConnection connection) async{
    try {
      final credentials = LoginModel.fromJson(json.decode(await req.readAsString()));
      validator.validate(credentials);
      final result = await repository.interact(connection: connection, credentials: credentials, params: req, isBypassed: false);
      return Response.ok(json.encode({'token': result.$2}));
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
  List<ActionPermission> get permissionsList => [];
  
  @override
  IValidator validator = LoginValidator();

  @override
  IRepository<DBConnection, LoginModel> get repository => LoginRepository();

  @override
  Handler handler({required DBConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

}