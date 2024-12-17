import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetUserRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    if(credentials.length<24){
      throw FormatException();
    }
    final userRaw = await connection.users.findOne(where.eq('_id', ObjectId.fromHexString(credentials)));
    if (userRaw == null) {
      throw NotFoundException();
    }
    final user = UserDBMongo.fromJson(userRaw);
    return (true, json.encode(user.toUserResponse().toJson()));
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required String credentials, 
    Request? params,
  }) async {
    try {

      final result = await connection.db.query(
        '''
        SELECT u.id, u.full_name, u.email, u.role, u.avatar
        FROM users u
        WHERE u.id = @userId
        ''',
        substitutionValues: {'userId': credentials}
      );

      if (result.isEmpty) {
        throw NotFoundException();
      }

      final userData = result.first.toColumnMap();
      final user = UserDBPostgre(
        id: userData['id'],
        fullName: userData['full_name'],
        email: userData['email'],
        role: PermissionLevel.fromInt(userData['role']),
        avatar: userData['avatar'],
        password: null,
      );

      return (true, json.encode(user.toUserResponse().toJson()));
    } catch (e) {
      throw NotFoundException("User not found or error occurred: $e");
    }
  }

}