import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'environment.dart';
import 'permission_level.dart';

class JWTProvider{

  static String issueJwt(String userId, PermissionLevel permissionLevel) {
    final String secretKey = Environment.getSecretKey();
    final jwt = JWT(
      
      {
        'id': userId,
        'permissionLevel': permissionLevel.value, 
        'exp': DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000
      },
      
    );
    return jwt.sign(SecretKey(secretKey));
  }
  
}