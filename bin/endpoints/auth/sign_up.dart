import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import '../../models/result_models.dart';
import '../../models/sign_up_model.dart';
import '../../mongo_connection.dart';
import '../../utils/constants.dart';
import '../../utils/handler_interface.dart';

class SignUp {
  static IPostHandler call(){
    final String dbType = (DotEnv()..load()).getOrElse('DB_TYPE', () => '');
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
      final validation = validate(signUpRequest);
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
          return Response(400, body: json.encode(ErrorMessage(message: "User exists", statusCode: 400).toJson()));
        }
        return Response.ok( json.encode({"result": "success"}));
      }
      return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(message: e.toString(), statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  (bool, ErrorMessage?) validate(dynamic data) {
    if (data is SignUpModel){
      RegExp regex = RegExp(Constants.emailRegEx);
      Map<String, dynamic> messageMap = {};
      if(data.email.isEmpty || !regex.hasMatch(data.email)){
        messageMap["email"] = "Can not be empty or has non E-mail stucture";
      }
      if(data.fullName == null || data.fullName!.isEmpty){
        messageMap["full_name"] = "Can not be empty";
      }
      if(data.password.isEmpty){
        messageMap["password"]="Can not be empty";
      }
      if(data.role == null || data.role! > 3){
        messageMap["role"] = "Can not be empty on higher than 3";
      }
      return messageMap.isEmpty ? (true, null) : (false, ErrorMessage(message: messageMap.toString(), statusCode: 400));
    }else{
      return (false, ErrorMessage(message: "Bad request", statusCode: 400));
    }
  }
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
  (bool, ErrorMessage?) validate(data) {
    // TODO: implement validate
    throw UnimplementedError();
  }
}