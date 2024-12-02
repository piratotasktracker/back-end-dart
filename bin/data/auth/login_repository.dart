import 'package:bcrypt/bcrypt.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../models/login_model.dart';
import '../../models/user_db_model.dart';
import '../../db_connection.dart';
import '../../utils/jwt_provider.dart';
import '../repository_interface.dart';

class LoginRepository extends IRepository<DBConnection, LoginModel>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required LoginModel credentials, 
    Map<String, dynamic>? params,
  }) async{
    final userRaw = await connection.users.findOne(where.eq('email', credentials.email));
    if (userRaw == null) {
      return (false, 'Incorrect login or password');
    }
    final user = UserDBModel.fromJson(userRaw);
    if (BCrypt.checkpw(credentials.password, user.password)) {
      return (true, JWTProvider.issueJwt(user.id, user.role));
    }
    return (false, 'Incorrect login or password');  
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required LoginModel credentials, 
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

}