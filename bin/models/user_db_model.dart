import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';
import '../utils/permission_level.dart';

part 'user_db_model.g.dart';

abstract class IUserModel{

  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "full_name")
  final String fullName;
  @JsonEnum(valueField: "role")
  final PermissionLevel role;

  const IUserModel({
    required this.avatar,
    required this.email,
    required this.fullName,
    required this.role
  });
}

@JsonSerializable()
class UserDBMongo extends IUserModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "password")
  final String password;

  const UserDBMongo({
    required super.avatar,
    required this.id,
    required super.email,
    required super.fullName,
    required this.password,
    required super.role
  });

  UserResponse toUserResponse(){
    return UserResponse(
      avatar: avatar, 
      id: id, 
      email: email, 
      fullName: fullName, 
      role: role
    );
  }

  factory UserDBMongo.fromJson(Map<String, dynamic> json) => _$UserDBMongoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDBMongoToJson(this);

}

@JsonSerializable()
class UserDBPostgre extends IUserModel{
  final int id;
  @JsonKey(name: "password")
  final String password;

  const UserDBPostgre({
    required super.avatar,
    required this.id,
    required super.email,
    required super.fullName,
    required this.password,
    required super.role
  });

  UserResponse toUserResponse(){
    return UserResponse(
      avatar: avatar, 
      id: id.toString(), 
      email: email, 
      fullName: fullName, 
      role: role
    );
  }

  factory UserDBPostgre.fromJson(Map<String, dynamic> json) => _$UserDBPostgreFromJson(json);

  Map<String, dynamic> toJson() => _$UserDBPostgreToJson(this);

}

@JsonSerializable()
class UserResponse extends IUserModel{
  @JsonKey(name: 'id')
  final String id;

  const UserResponse({
    required super.avatar,
    required this.id,
    required super.email,
    required super.fullName,
    required super.role
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

}

