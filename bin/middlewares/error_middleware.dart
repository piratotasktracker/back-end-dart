import 'package:shelf/shelf.dart';

import '../utils/error_handler.dart';

Middleware errorHandlingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      try {
        return await handler(request);
      } catch (error, stackTrace) {
        print('Error: $error\nStackTrace: $stackTrace');
        return ErrorHandler.handle(error as Exception);
      }
    };
  };
}
