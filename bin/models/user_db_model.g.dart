// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_db_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDBModel _$UserDBModelFromJson(Map<String, dynamic> json) => UserDBModel(
      avatar: json['avatar'] as String?,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      password: json['password'] as String,
      role: (json['role'] as num).toInt(),
    );

Map<String, dynamic> _$UserDBModelToJson(UserDBModel instance) =>
    <String, dynamic>{
      '_id': const ObjectIdConverter().toJson(instance.id),
      'email': instance.email,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
      'password': instance.password,
      'role': instance.role,
    };

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      avatar: json['avatar'] as String?,
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      password: json['password'] as String,
      role: (json['role'] as num).toInt(),
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
      'password': instance.password,
      'role': instance.role,
    };
