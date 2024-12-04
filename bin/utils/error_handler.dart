import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../models/result_models.dart';

class ErrorHandler {
  static Response handle(Exception error) {
    print(error.toString());
    if (error is MongoDartError) {
      return Response.internalServerError(
        body: json.encode(ErrorMessage(result: 'Database error: $error', statusCode: 500).toJson()),
      );
    } else if (error is FormatException) {
      return Response.badRequest(
        body: json.encode(ErrorMessage(result: 'BadRequest: ${error.message.isEmpty ? 'wrond format or id' : error.message}', statusCode: 400).toJson()),
      );
    } else if (error is UnauthorizedException) {
      return Response.forbidden(jsonEncode(ErrorMessage(result: 'BadRequest: ${error.message}', statusCode: 401).toJson()));
    } else if (error is NotFoundException) {
      return Response.notFound(jsonEncode(ErrorMessage(result: error.message, statusCode: 404).toJson()));
    } else if (error is LoginException) {
      return Response.forbidden(jsonEncode(ErrorMessage(result: error.message, statusCode: 401).toJson()));
    } else {
      return Response.internalServerError(
        body: jsonEncode(ErrorMessage(result: 'Unknown error occurred: $error', statusCode: 500).toJson())
      );
    }
  }
}


class UnauthorizedException implements Exception {
  final String message;
  const UnauthorizedException([this.message = 'Permission denied']);
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException([this.message = 'Resource not found']);
}

class LoginException implements Exception {
  final String message;
  const LoginException([this.message = 'Incorrect login or password']);
}

class UserExistsException implements Exception {
  final String message;
  const UserExistsException([this.message = 'User exists']);
}