

import 'package:shelf/shelf.dart';

import '../models/result_models.dart';
import '../mongo_connection.dart';

abstract interface class IHandler {
  
  Future<Response> rootHandler(Request req, MongoConnection connection);

  Handler handler({required MongoConnection connection});

}

abstract interface class IPostHandler extends IHandler{
  (bool, ErrorMessage?) validate(dynamic data);
}