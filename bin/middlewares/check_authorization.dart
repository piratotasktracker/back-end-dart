import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../models/result_models.dart';
import '../utils/environment.dart';

Middleware checkAuthorization() {
  return (Handler handler) {
    return (Request request) async {

      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden(json.encode(ErrorMessage(result: 'Authorization header is missing or invalid', statusCode: 403).toJson()));
      }

      final token = authHeader.substring(7);
      final secretKey = Environment.getSecretKey();

      try {
        final session = JWT.verify(token, SecretKey(secretKey));
        return await handler(request.change(context: {
          'userId': (session.payload as Map<String, dynamic>)["id"],
          'permissionLevel': (session.payload as Map<String, dynamic>)["permissionLevel"]
        }));
      } catch (e) {
        return Response.forbidden(json.encode(ErrorMessage(result: 'Invalid or expired token', statusCode: 403).toJson()));
      }
      
    };
  };
}