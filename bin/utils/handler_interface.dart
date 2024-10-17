

import 'package:shelf/shelf.dart';

import '../models/result_models.dart';
import '../mongo_connection.dart';
import 'permission_level.dart';

abstract interface class IHandler {
  
  Future<Response> rootHandler(Request req, MongoConnection connection);

  Handler handler({required MongoConnection connection});

  final PermissionLevel permissionLevel;

  const IHandler({required this.permissionLevel});

}

abstract interface class IPostHandler extends IHandler{

  (bool, ErrorMessage?) validate(dynamic data);

  IPostHandler({required super.permissionLevel});

}