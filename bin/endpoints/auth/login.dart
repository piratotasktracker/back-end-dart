import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/result_models.dart';
import '../../models/login_model.dart';
import '../../models/user_db_model.dart';
import '../../mongo_connection.dart';
import '../../utils/constants.dart';
import '../../utils/handler_interface.dart';
import '../../utils/jwt_provider.dart';

class Login {
  static IPostHandler call(){
    final String dbType = (DotEnv()..load()).getOrElse('DB_TYPE', () => '');
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
      final validation = validate(credentials);
      if(validation.$1){
        final userRaw = await connection.users.findOne(where.eq('email', credentials.email));
        if (userRaw == null) {
          return Response.notFound(json.encode(ErrorMessage(message: "User not found", statusCode: 404).toJson()));
        }
        var user = UserDBModel.fromJson(userRaw);
        if (BCrypt.checkpw(credentials.password, user.password)) {
          final token = JWTProvider.issueJwt(user.id);
          return Response.ok(json.encode({'token': token}));
        }
        return Response(400, body: json.encode(ErrorMessage(message: "Invalid e-mail or password", statusCode: 400).toJson()));
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: 'Error fetching user: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  (bool, ErrorMessage?) validate(data) {
    if (data is LoginModel){
      RegExp regex = RegExp(Constants.emailRegEx);
      Map<String, dynamic> messageMap = {};
      if(data.email.isEmpty || !regex.hasMatch(data.email)){
        messageMap["email"] = "Can not be empty or has non E-mail stucture";
      }
      if(data.password.isEmpty){
        messageMap["password"]="Can not be empty";
      }
      return messageMap.isEmpty ? (true, null) : (false, ErrorMessage(message: messageMap.toString(), statusCode: 400));
    }else{
      return (false, ErrorMessage(message: "Bad request", statusCode: 400));
    }
  }
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
  (bool, ErrorMessage?) validate(data) {
    // TODO: implement validate
    throw UnimplementedError();
  }
}