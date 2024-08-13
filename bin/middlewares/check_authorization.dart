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
        return Response.forbidden(json.encode(ErrorMessage(message: 'Authorization header is missing or invalid', statusCode: 403).toJson()));
      }

      final token = authHeader.substring(7);
      final secretKey = Environment.getSecretKey();

      try {
        JWT.verify(token, SecretKey(secretKey));
        return await handler(request);
      } catch (e) {
        return Response.forbidden(json.encode(ErrorMessage(message: 'Invalid or expired token', statusCode: 403).toJson()));
      }
      
    };
  };
}