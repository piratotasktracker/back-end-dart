import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../db_connection.dart';
import '../models/role_model.dart';
import 'error_handler.dart';
import 'permission_level.dart';

mixin PermissionCheckMixin {
  Future<bool> checkPermissions({
    required List<ActionPermission> permissionsList, 
    required DBConnection connection,
    required Request params
  }) async {
    if(permissionsList.isNotEmpty){
      if(connection is MongoConnection){
        final roleRaw = await connection.roles.findOne(where.eq('_id', ObjectId.fromHexString(params.context["roleId"] as String)));
        if (roleRaw == null) {
          throw NotFoundException();
        }
        final role = RoleMongoModel.fromJson(roleRaw);
        return _validatePermissions(permissionsList, role);
      }else if(connection is PostgreConnection){
        //TODO: Implement for postgre
        throw UnimplementedError();
      }
    }
    return false;
  }

  bool _validatePermissions(List<ActionPermission> permissionsList, IRoleModel role){
    if(!role.isAdmin){
      for (var i in permissionsList){
        switch (i) {
          case ActionPermission.canCreateProjects:
            if(!role.canCreateProjects) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canUpdateProjects:
            if(!role.canUpdateProjects) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canDeleteProjects:
            if(!role.canDeleteProjects) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canGetProjects:
            if(!role.canGetProjects) throw UnauthorizedException('Access forbidden'); 

          case ActionPermission.canCreateTasks:
            if(!role.canCreateTasks) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canUpdateTasks:
            if(!role.canUpdateTasks) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canDeleteTasks:
            if(!role.canDeleteTasks) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canGetTasks:
            if(!role.canGetTasks) throw UnauthorizedException('Access forbidden'); 

          case ActionPermission.canUpdateUsers:
            if(!role.canUpdateUsers) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canDeleteUsers:
            if(!role.canDeleteUsers) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canGetUsers:
            if(!role.canGetUsers) throw UnauthorizedException('Access forbidden'); 

          case ActionPermission.canCreateRoles:
            if(!role.canCreateRoles) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canUpdateRoles:
            if(!role.canUpdateRoles) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canDeleteRoles:
            if(!role.canDeleteRoles) throw UnauthorizedException('Access forbidden'); 
          case ActionPermission.canGetRoles:
            if(!role.canGetRoles) throw UnauthorizedException('Access forbidden'); 
        } 
      }
    }else{
      return true;
    }
    return false;
  }
}