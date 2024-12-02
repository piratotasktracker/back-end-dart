import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/user_db_model.dart';
import '../repository_interface.dart';

class GetUserRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    final userRaw = await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(credentials)));
    if (userRaw == null) {
      return (false, 'User not found');
    }
    final user = UserDBModel.fromJson(userRaw);
    return (true, json.encode(user.toUserResponse().toJson()));
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required String credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}