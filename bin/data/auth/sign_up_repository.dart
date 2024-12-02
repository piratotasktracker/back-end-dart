import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../models/sign_up_model.dart';
import '../../db_connection.dart';
import '../repository_interface.dart';

class SignUpRepository extends IRepository<DBConnection, SignUpModel>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required SignUpModel credentials,
    Map<String, dynamic>? params,
  }) async{
    final Map<String, dynamic>? signUpRequestRaw = await connection.users.findOne(where.eq('email', credentials.email));
    if (signUpRequestRaw != null) {
      final hashedPassword = BCrypt.hashpw(credentials.password, BCrypt.gensalt());
      await connection.users.insertOne({
        "email": credentials.email,
        "password": hashedPassword,
        "full_name": credentials.fullName,
        "avatar": credentials.avatar,
        "role": credentials.role
      });
    }else{
      return (false, 'User exists');
    }
    return (false, json.encode({"result": "success"}));
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required SignUpModel credentials,
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

}