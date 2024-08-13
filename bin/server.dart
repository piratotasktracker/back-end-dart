import 'dart:io';

import 'package:dotenv/dotenv.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'middlewares/headers_middleware.dart';
import 'mongo_connection.dart';
import 'router/router.dart';
import 'utils/swagger_handler.dart';

void main(List<String> args) async {

  final String mongoConnectionString = (DotEnv()..load()).getOrElse('MONGO_DB_URI', () => '');
  if (mongoConnectionString.isNotEmpty){
    final MongoConnection connection = MongoConnection();
    await connection.initialize(connectionString: mongoConnectionString);
    final ip = InternetAddress.anyIPv4;
    
    AppRouter router = AppRouter(connection: connection)..initialize();

    final handler = Cascade().add(SwaggerManager.swaggerHandler).add(router.router).handler;
    final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(SwaggerManager.swaggerMiddleware)
      .addMiddleware(addContentType('application/json'))
      .addHandler(handler);

    final port = int.parse(Platform.environment['PORT'] ?? '8080');
    final server = await serve(pipeline, ip, port);
    print('Server listening on port ${server.port}');
    ProcessSignal.sigint.watch().listen((signal) async {
      print('Received SIGINT, closing MongoDB connection...');
      await connection.close();
      await server.close();
      print('Server stopped');
      exit(0);
    });
  }
}
