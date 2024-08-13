import 'package:shelf/shelf.dart';

Middleware addContentType(String contentType) {
  return (Handler handler) {
    return (Request request) async {
      Response response = await handler(request);
      return response.change(headers: {
        'Content-Type': '$contentType; charset=utf-8',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        'Access-Control-Allow-Credentials': 'true',
      });
    };
  };
}