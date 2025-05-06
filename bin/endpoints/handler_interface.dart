import 'package:shelf/shelf.dart';

import '../data/repository_interface.dart';
import '../db_connection.dart';
import '../validators/validator_interface.dart';
import '../utils/permission_level.dart';

abstract interface class IHandler{
  
  Future<Response> rootHandler(Request req, DBConnection connection);

  Handler handler({required DBConnection connection});

  final List<ActionPermission> permissionsList;

  final IRepository repository;

  const IHandler({required this.permissionsList, required this.repository});

}

abstract interface class IPostHandler extends IHandler{

  IValidator validator;

  IPostHandler({required super.permissionsList, required super.repository, required this.validator});

}