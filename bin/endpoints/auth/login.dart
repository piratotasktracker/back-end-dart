import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/login_model.dart';
import '../../models/user_db_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../handler_interface.dart';
import '../../utils/jwt_provider.dart';
import '../../utils/permission_level.dart';
import '../../validators/auth/login_validator.dart';
import '../../validators/validator_interface.dart';

class Login {
  static IPostHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return LoginMongo();
      }
      case "POSTGRESQL":{
        return LoginProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class LoginMongo implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final credentials = LoginModel.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(credentials);
      if(validation.$1){
        final userRaw = await connection.users.findOne(where.eq('email', credentials.email));
        if (userRaw == null) {
          return Response.notFound(json.encode(ErrorMessage(result: "User not found", statusCode: 404).toJson()));
        }
        final user = UserDBModel.fromJson(userRaw);
        if (BCrypt.checkpw(credentials.password, user.password)) {
          final token = JWTProvider.issueJwt(user.id, user.role);
          return Response.ok(json.encode({'token': token}));
        }
        return Response(400, body: json.encode(ErrorMessage(result: "Invalid e-mail or password", statusCode: 400).toJson()));
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error fetching user: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }
  
  @override
  PermissionLevel get permissionLevel => PermissionLevel.unknown;
  
  @override
  IValidator validator = LoginValidator();

}

class LoginProstgre implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.unknown;
  
  @override
  IValidator validator = LoginValidator();
}