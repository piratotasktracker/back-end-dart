import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';

part 'role_model.g.dart';

abstract class IRoleModel {
  final String name;
  
  // General parameter
  final bool isAdmin;

  // Projects permissions
  final bool canCreateProjects;
  final bool canUpdateProjects;
  final bool canDeleteProjects;
  final bool canGetProjects;
  
  // Tasks permissions
  final bool canCreateTasks;
  final bool canUpdateTasks;
  final bool canDeleteTasks;
  final bool canGetTasks;
  
  // Users permissions
  final bool canUpdateUsers;
  final bool canDeleteUsers;
  final bool canGetUsers;
  
  // Roles permissions
  final bool canCreateRoles;
  final bool canUpdateRoles;
  final bool canDeleteRoles;
  final bool canGetRoles;

  const IRoleModel({
    required this.name,
    required this.isAdmin,
    required this.canCreateProjects,
    required this.canUpdateProjects,
    required this.canDeleteProjects,
    required this.canGetProjects,
    required this.canCreateTasks,
    required this.canUpdateTasks,
    required this.canDeleteTasks,
    required this.canGetTasks,
    required this.canUpdateUsers,
    required this.canDeleteUsers,
    required this.canGetUsers,
    required this.canCreateRoles,
    required this.canUpdateRoles,
    required this.canDeleteRoles,
    required this.canGetRoles,
  });
} 

@JsonSerializable()
class RoleRequest extends IRoleModel {
  const RoleRequest({
    required super.name,
    required super.isAdmin,
    required super.canCreateProjects,
    required super.canCreateRoles,
    required super.canCreateTasks,
    required super.canDeleteProjects,
    required super.canDeleteRoles,
    required super.canDeleteTasks,
    required super.canDeleteUsers,
    required super.canGetProjects,
    required super.canGetRoles,
    required super.canGetTasks,
    required super.canGetUsers,
    required super.canUpdateProjects,
    required super.canUpdateRoles,
    required super.canUpdateTasks,
    required super.canUpdateUsers,
  });

  factory RoleRequest.fromJson(Map<String, dynamic> json) => _$RoleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RoleRequestToJson(this);

}

@JsonSerializable()
class RoleResponse extends IRoleModel {
  final String id;
  const RoleResponse({
    required this.id,
    required super.name,
    required super.isAdmin,
    required super.canCreateProjects,
    required super.canCreateRoles,
    required super.canCreateTasks,
    required super.canDeleteProjects,
    required super.canDeleteRoles,
    required super.canDeleteTasks,
    required super.canDeleteUsers,
    required super.canGetProjects,
    required super.canGetRoles,
    required super.canGetTasks,
    required super.canGetUsers,
    required super.canUpdateProjects,
    required super.canUpdateRoles,
    required super.canUpdateTasks,
    required super.canUpdateUsers,
  });

  factory RoleResponse.fromJson(Map<String, dynamic> json) => _$RoleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RoleResponseToJson(this);

}

@JsonSerializable()
class RoleMongoModel extends IRoleModel {
  
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;

  const RoleMongoModel({
    required this.id,
    required super.name,
    required super.isAdmin,
    required super.canCreateProjects,
    required super.canCreateRoles,
    required super.canCreateTasks,
    required super.canDeleteProjects,
    required super.canDeleteRoles,
    required super.canDeleteTasks,
    required super.canDeleteUsers,
    required super.canGetProjects,
    required super.canGetRoles,
    required super.canGetTasks,
    required super.canGetUsers,
    required super.canUpdateProjects,
    required super.canUpdateRoles,
    required super.canUpdateTasks,
    required super.canUpdateUsers,
  });

  RoleResponse toRoleResponse(){
    return RoleResponse(
      id: id, 
      name: name, 
      isAdmin: isAdmin, 
      canCreateProjects: canCreateProjects, 
      canCreateRoles: canCreateRoles, 
      canCreateTasks: canCreateTasks, 
      canDeleteProjects: canDeleteProjects, 
      canDeleteRoles: canDeleteRoles, 
      canDeleteTasks: canDeleteTasks, 
      canDeleteUsers: canDeleteUsers, 
      canGetProjects: canGetProjects, 
      canGetRoles: canGetRoles, 
      canGetTasks: canGetTasks, 
      canGetUsers: canGetUsers, 
      canUpdateProjects: canUpdateProjects, 
      canUpdateRoles: canUpdateRoles, 
      canUpdateTasks: canUpdateTasks, 
      canUpdateUsers: canUpdateUsers,
    );
  }

  factory RoleMongoModel.fromJson(Map<String, dynamic> json) => _$RoleMongoModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleMongoModelToJson(this);

}