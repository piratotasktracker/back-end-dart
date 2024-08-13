// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpModel _$SignUpModelFromJson(Map<String, dynamic> json) => SignUpModel(
      avatar: json['avatar'] as String?,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      password: json['password'] as String,
      role: (json['role'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SignUpModelToJson(SignUpModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'avatar': instance.avatar,
      'full_name': instance.fullName,
      'password': instance.password,
      'role': instance.role,
    };
