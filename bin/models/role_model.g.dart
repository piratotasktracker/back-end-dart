// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleRequest _$RoleRequestFromJson(Map<String, dynamic> json) => RoleRequest(
      name: json['name'] as String,
      isAdmin: json['isAdmin'] as bool,
      canCreateProjects: json['canCreateProjects'] as bool,
      canCreateRoles: json['canCreateRoles'] as bool,
      canCreateTasks: json['canCreateTasks'] as bool,
      canDeleteProjects: json['canDeleteProjects'] as bool,
      canDeleteRoles: json['canDeleteRoles'] as bool,
      canDeleteTasks: json['canDeleteTasks'] as bool,
      canDeleteUsers: json['canDeleteUsers'] as bool,
      canGetProjects: json['canGetProjects'] as bool,
      canGetRoles: json['canGetRoles'] as bool,
      canGetTasks: json['canGetTasks'] as bool,
      canGetUsers: json['canGetUsers'] as bool,
      canUpdateProjects: json['canUpdateProjects'] as bool,
      canUpdateRoles: json['canUpdateRoles'] as bool,
      canUpdateTasks: json['canUpdateTasks'] as bool,
      canUpdateUsers: json['canUpdateUsers'] as bool,
    );

Map<String, dynamic> _$RoleRequestToJson(RoleRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isAdmin': instance.isAdmin,
      'canCreateProjects': instance.canCreateProjects,
      'canUpdateProjects': instance.canUpdateProjects,
      'canDeleteProjects': instance.canDeleteProjects,
      'canGetProjects': instance.canGetProjects,
      'canCreateTasks': instance.canCreateTasks,
      'canUpdateTasks': instance.canUpdateTasks,
      'canDeleteTasks': instance.canDeleteTasks,
      'canGetTasks': instance.canGetTasks,
      'canUpdateUsers': instance.canUpdateUsers,
      'canDeleteUsers': instance.canDeleteUsers,
      'canGetUsers': instance.canGetUsers,
      'canCreateRoles': instance.canCreateRoles,
      'canUpdateRoles': instance.canUpdateRoles,
      'canDeleteRoles': instance.canDeleteRoles,
      'canGetRoles': instance.canGetRoles,
    };

RoleResponse _$RoleResponseFromJson(Map<String, dynamic> json) => RoleResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      isAdmin: json['isAdmin'] as bool,
      canCreateProjects: json['canCreateProjects'] as bool,
      canCreateRoles: json['canCreateRoles'] as bool,
      canCreateTasks: json['canCreateTasks'] as bool,
      canDeleteProjects: json['canDeleteProjects'] as bool,
      canDeleteRoles: json['canDeleteRoles'] as bool,
      canDeleteTasks: json['canDeleteTasks'] as bool,
      canDeleteUsers: json['canDeleteUsers'] as bool,
      canGetProjects: json['canGetProjects'] as bool,
      canGetRoles: json['canGetRoles'] as bool,
      canGetTasks: json['canGetTasks'] as bool,
      canGetUsers: json['canGetUsers'] as bool,
      canUpdateProjects: json['canUpdateProjects'] as bool,
      canUpdateRoles: json['canUpdateRoles'] as bool,
      canUpdateTasks: json['canUpdateTasks'] as bool,
      canUpdateUsers: json['canUpdateUsers'] as bool,
    );

Map<String, dynamic> _$RoleResponseToJson(RoleResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isAdmin': instance.isAdmin,
      'canCreateProjects': instance.canCreateProjects,
      'canUpdateProjects': instance.canUpdateProjects,
      'canDeleteProjects': instance.canDeleteProjects,
      'canGetProjects': instance.canGetProjects,
      'canCreateTasks': instance.canCreateTasks,
      'canUpdateTasks': instance.canUpdateTasks,
      'canDeleteTasks': instance.canDeleteTasks,
      'canGetTasks': instance.canGetTasks,
      'canUpdateUsers': instance.canUpdateUsers,
      'canDeleteUsers': instance.canDeleteUsers,
      'canGetUsers': instance.canGetUsers,
      'canCreateRoles': instance.canCreateRoles,
      'canUpdateRoles': instance.canUpdateRoles,
      'canDeleteRoles': instance.canDeleteRoles,
      'canGetRoles': instance.canGetRoles,
      'id': instance.id,
    };

RoleMongoModel _$RoleMongoModelFromJson(Map<String, dynamic> json) =>
    RoleMongoModel(
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      name: json['name'] as String,
      isAdmin: json['isAdmin'] as bool,
      canCreateProjects: json['canCreateProjects'] as bool,
      canCreateRoles: json['canCreateRoles'] as bool,
      canCreateTasks: json['canCreateTasks'] as bool,
      canDeleteProjects: json['canDeleteProjects'] as bool,
      canDeleteRoles: json['canDeleteRoles'] as bool,
      canDeleteTasks: json['canDeleteTasks'] as bool,
      canDeleteUsers: json['canDeleteUsers'] as bool,
      canGetProjects: json['canGetProjects'] as bool,
      canGetRoles: json['canGetRoles'] as bool,
      canGetTasks: json['canGetTasks'] as bool,
      canGetUsers: json['canGetUsers'] as bool,
      canUpdateProjects: json['canUpdateProjects'] as bool,
      canUpdateRoles: json['canUpdateRoles'] as bool,
      canUpdateTasks: json['canUpdateTasks'] as bool,
      canUpdateUsers: json['canUpdateUsers'] as bool,
    );

Map<String, dynamic> _$RoleMongoModelToJson(RoleMongoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'isAdmin': instance.isAdmin,
      'canCreateProjects': instance.canCreateProjects,
      'canUpdateProjects': instance.canUpdateProjects,
      'canDeleteProjects': instance.canDeleteProjects,
      'canGetProjects': instance.canGetProjects,
      'canCreateTasks': instance.canCreateTasks,
      'canUpdateTasks': instance.canUpdateTasks,
      'canDeleteTasks': instance.canDeleteTasks,
      'canGetTasks': instance.canGetTasks,
      'canUpdateUsers': instance.canUpdateUsers,
      'canDeleteUsers': instance.canDeleteUsers,
      'canGetUsers': instance.canGetUsers,
      'canCreateRoles': instance.canCreateRoles,
      'canUpdateRoles': instance.canUpdateRoles,
      'canDeleteRoles': instance.canDeleteRoles,
      'canGetRoles': instance.canGetRoles,
      '_id': const ObjectIdConverter().toJson(instance.id),
    };
