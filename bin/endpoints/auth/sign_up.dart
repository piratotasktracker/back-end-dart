import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../models/result_models.dart';
import '../../models/sign_up_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../validators/auth/sign_in_validator.dart';
import '../../validators/validator_interface.dart';
import '../handler_interface.dart';
import '../../utils/permission_level.dart';

class SignUp {
  static IPostHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return SignUpMongo();
      }
      case "POSTGRESQL":{
        return SignUpProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class SignUpMongo implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final signUpRequest = SignUpModel.fromJson(json.decode(await req.readAsString()));
      final validation = validator.validate(signUpRequest);
      if(validation.$1){
        final Map<String, dynamic>? signUpRequestRaw = await connection.users.findOne(where.eq('email', signUpRequest.email));
        if (signUpRequestRaw != null) {
          final hashedPassword = BCrypt.hashpw(signUpRequest.password, BCrypt.gensalt());
          await connection.users.insertOne({
            "email": signUpRequest.email,
            "password": hashedPassword,
            "full_name": signUpRequest.fullName,
            "avatar": signUpRequest.avatar,
            "role": signUpRequest.role
          });
        }else{
          return Response(400, body: json.encode(ErrorMessage(result: "User exists", statusCode: 400).toJson()));
        }
        return Response.ok( json.encode({"result": "success"}));
      }
      return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: e.toString(), statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.unknown;

  @override
  IValidator validator = SignUpValidator();

}

class SignUpProstgre implements IPostHandler{

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
  IValidator validator = SignUpValidator();

}