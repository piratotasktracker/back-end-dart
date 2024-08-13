import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf.dart';

import '../models/result_models.dart';

Middleware checkAuthorization() {
  return (Handler handler) {
    return (Request request) async {

      final authHeader = request.headers['Authorization'];
      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.forbidden(json.encode(ErrorMessage(message: 'Authorization header is missing or invalid', statusCode: 403).toJson()));
      }

      final token = authHeader.substring(7);
      final secretKey = (DotEnv()..load()).getOrElse('JWT_SECRET_KEY', () => '');

      try {
        JWT.verify(token, SecretKey(secretKey));
        return await handler(request);
      } catch (e) {
        return Response.forbidden(json.encode(ErrorMessage(message: 'Invalid or expired token', statusCode: 403).toJson()));
      }
      
    };
  };
}