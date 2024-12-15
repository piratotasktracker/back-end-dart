import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'middlewares/headers_middleware.dart';
import 'db_connection.dart';
import 'router/router.dart';
import 'utils/environment.dart';
import 'utils/swagger_handler.dart';

/// TODO: https://pub.dev/packages/flutter_quill/score
void main(List<String> args) async {
  
  String mongoConnectionString = Environment.getDBUri();
  if (mongoConnectionString.isNotEmpty){
    final DBConnection connection;
    if(Environment.getDBType() == 'MONGODB'){
      connection = MongoConnection();
    }else{
      connection = PostgreConnection();
    }
    await connection.initialize(connectionString: mongoConnectionString);
    final ip = InternetAddress.anyIPv4;
    
    AppRouter router = AppRouter(connection: connection)..initialize();

    final handler = Cascade().add(SwaggerManager.swaggerHandler).add(router.router).handler;
    final pipeline = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(SwaggerManager.swaggerMiddleware)
      .addMiddleware(addContentType('application/json'))
      .addHandler(handler);

    final port = int.parse(Platform.environment['PORT'] ?? '8081');
    final server = await serve(pipeline, ip, port);
    print('Server listening on port ${server.port}');
    ProcessSignal.sigint.watch().listen((signal) async {
      print('Received SIGINT, closing DB connection...');
      await connection.close();
      await server.close();
      print('Server stopped');
      exit(0);
    });
  }
}
