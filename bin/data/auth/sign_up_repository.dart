import 'dart:convert';

import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/sign_up_model.dart';
import '../../db_connection.dart';
import '../../utils/error_handler.dart';
import '../repository_interface.dart';

class SignUpRepository extends IRepository<DBConnection, SignUpModel>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required SignUpModel credentials,
    Request? params,
  }) async{
    final Map<String, dynamic>? signUpRequestRaw = await connection.users.findOne(where.eq('email', credentials.email));
    if (signUpRequestRaw == null) {
      final hashedPassword = BCrypt.hashpw(credentials.password, BCrypt.gensalt());
      await connection.users.insertOne({
        "email": credentials.email,
        "password": hashedPassword,
        "full_name": credentials.full_name,
        "avatar": credentials.avatar,
        "role": credentials.role
      });
    }else{
      throw UserExistsException();
    }
    return (true, json.encode({"result": "success"}));
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required SignUpModel credentials,
    Request? params,
  }) async {
    final result = await connection.db.query(
      'SELECT id FROM users WHERE email = @email',
      substitutionValues: {
        'email': credentials.email
      },
    );
    if (result.isNotEmpty) {
      throw UserExistsException();
    }
    final hashedPassword = BCrypt.hashpw(credentials.password, BCrypt.gensalt());

    await connection.db.query(
      'INSERT INTO users (email, password, full_name, avatar, role) VALUES (@email, @password, @full_name, @avatar, @role)',
      substitutionValues: {
        'email': credentials.email,
        'password': hashedPassword,
        'full_name': credentials.full_name,
        'avatar': credentials.avatar,
        'role': credentials.role,
      },
    );

    return (true, json.encode({"result": "success"}));
  }

}