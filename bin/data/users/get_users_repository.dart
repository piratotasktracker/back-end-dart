import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
import '../../utils/permission_level.dart';
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
  }) async {
    try {
      final result = await connection.db.query(
        '''
        SELECT u.id, u.full_name, u.email, u.role, u.avatar
        FROM users u
      ''');

      if (result.isEmpty) {
        throw NotFoundException("No users found");
      }

      final users = result.map((row) {
        final userData = row.toColumnMap();
        return UserDBPostgre(
          id: userData['id'],
          fullName: userData['full_name'],
          email: userData['email'],
          role: PermissionLevel.fromInt(userData['role']),
          avatar: userData['avatar'],
          password: null,
        );
      }).toList();

      return (true, json.encode(users.map((user) => user.toUserResponse().toJson()).toList()));
    } catch (e) {
      throw NotFoundException("Error fetching users: $e");
    }
  }

}