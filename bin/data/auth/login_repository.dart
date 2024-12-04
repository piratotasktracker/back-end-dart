import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../models/login_model.dart';
import '../../models/user_db_model.dart';
import '../../db_connection.dart';
import '../../utils/error_handler.dart';
import '../../utils/jwt_provider.dart';
import '../repository_interface.dart';

class LoginRepository extends IRepository<DBConnection, LoginModel>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required LoginModel credentials, 
    Request? params,
  }) async{
    final userRaw = await connection.users.findOne(where.eq('email', credentials.email));
    if (userRaw == null) {
      throw LoginException(); 
    }
    final user = UserDBModel.fromJson(userRaw);
    if (BCrypt.checkpw(credentials.password, user.password)) {
      return (true, JWTProvider.issueJwt(user.id, user.role));
    }
    throw LoginException(); 
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required LoginModel credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}