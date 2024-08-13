import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';

part 'user_db_model.g.dart';

@JsonSerializable()
class UserDBModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "full_name")
  final String fullName;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "role")
  final int role;

  const UserDBModel({
    required this.avatar,
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
    required this.role
  });

  UserDTO toUserDTO(){
    return UserDTO(
      avatar: avatar, 
      id: id, 
      email: email, 
      fullName: fullName, 
      password: password, 
      role: role
    );
  }

  factory UserDBModel.fromJson(Map<String, dynamic> json) => _$UserDBModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDBModelToJson(this);

}

@JsonSerializable()
class UserDTO{
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "full_name")
  final String fullName;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "role")
  final int role;

  const UserDTO({
    required this.avatar,
    required this.id,
    required this.email,
    required this.fullName,
    required this.password,
    required this.role
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

}

