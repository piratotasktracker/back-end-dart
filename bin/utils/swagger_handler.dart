import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

class SwaggerManager{

  static FutureOr<Response> swaggerHandler (Request request) {
    if (request.url.path.startsWith('docs') || request.url.path.startsWith('swagger.yaml')) {
      return SwaggerUI('swagger.yaml', title: 'Swagger Test').call(request);
    }
    return Response.notFound('Not Found');
  }

  static Future<Response> Function(Request) swaggerMiddleware(Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      if (request.requestedUri.path.startsWith('/docs')) {
        return response.change(headers: {'Content-Type': 'text/html'});
      }
      return response;
    };
  }
}