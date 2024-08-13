import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'environment.dart';

class JWTProvider{

  static String issueJwt(String userId) {
    final String secretKey = Environment.getSecretKey();
    final jwt = JWT(
      {
        'id': userId,
        'exp': DateTime.now().add(Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000
      },
      
    );
    return jwt.sign(SecretKey(secretKey));
  }
  
}