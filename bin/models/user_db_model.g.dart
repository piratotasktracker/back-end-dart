// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDBMongo _$UserDBMongoFromJson(Map<String, dynamic> json) => UserDBMongo(
      avatar: json['avatar'] as String?,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      password: json['password'] as String,
      role: $enumDecode(_$PermissionLevelEnumMap, json['role']),
    );

Map<String, dynamic> _$UserDBMongoToJson(UserDBMongo instance) =>
    <String, dynamic>{
      'email': instance.email,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
      'role': _$PermissionLevelEnumMap[instance.role]!,
      '_id': const ObjectIdConverter().toJson(instance.id),
      'password': instance.password,
    };

const _$PermissionLevelEnumMap = {
  PermissionLevel.unknown: 0,
  PermissionLevel.executor: 1,
  PermissionLevel.manager: 2,
  PermissionLevel.administrator: 3,
  PermissionLevel.owner: 4,
};

UserDBPostgre _$UserDBPostgreFromJson(Map<String, dynamic> json) =>
    UserDBPostgre(
      avatar: json['avatar'] as String?,
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      password: json['password'] as String?,
      role: $enumDecode(_$PermissionLevelEnumMap, json['role']),
    );

Map<String, dynamic> _$UserDBPostgreToJson(UserDBPostgre instance) =>
    <String, dynamic>{
      'email': instance.email,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
      'role': _$PermissionLevelEnumMap[instance.role]!,
      'id': instance.id,
      'password': instance.password,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      avatar: json['avatar'] as String?,
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      role: $enumDecode(_$PermissionLevelEnumMap, json['role']),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
      'role': _$PermissionLevelEnumMap[instance.role]!,
      'id': instance.id,
    };
