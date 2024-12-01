import 'package:shelf/shelf.dart';


import '../mongo_connection.dart';
import '../validators/validator_interface.dart';
import '../utils/permission_level.dart';

abstract interface class IHandler {
  
  Future<Response> rootHandler(Request req, MongoConnection connection);

  Handler handler({required MongoConnection connection});

  final PermissionLevel permissionLevel;

  const IHandler({required this.permissionLevel});

}

abstract interface class IPostHandler extends IHandler{

  IValidator validator;

  IPostHandler({required super.permissionLevel, required this.validator});

}