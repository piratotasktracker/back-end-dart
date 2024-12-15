import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/user_db_model.dart';
import '../repository_interface.dart';

class GetUsersRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    final usersRaw = await connection.users.find().toList();
    final users = usersRaw.map((user) => UserDBMongo.fromJson(user)).toList();
    return (true, json.encode(users.map((user) => user.toUserResponse().toJson()).toList()));
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required void credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}