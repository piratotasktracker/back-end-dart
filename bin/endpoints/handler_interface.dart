import 'package:shelf/shelf.dart';


import '../data/repository_interface.dart';
import '../db_connection.dart';
import '../utils/error_handler.dart';
import '../validators/validator_interface.dart';
import '../utils/permission_level.dart';

abstract interface class IHandler {
  
  Future<Response> rootHandler(Request req, DBConnection connection);

  Handler handler({required DBConnection connection});

  final PermissionLevel permissionLevel;

  final IRepository repository;

  const IHandler({required this.permissionLevel, required this.repository});

}

abstract interface class IPostHandler extends IHandler{

  IValidator validator;

  IPostHandler({required super.permissionLevel, required super.repository, required this.validator});

}

mixin PermissionCheckMixin {
  void checkPermission({required Request req, required PermissionLevel permissionLevel}){
    final PermissionLevel userPermissionContext = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
    final String? userId = req.context["userId"] as String?;
    if(userPermissionContext.value < permissionLevel.value || userId == null){
      throw UnauthorizedException();
    }
  }
}