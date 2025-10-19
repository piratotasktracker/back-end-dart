import 'package:json_annotation/json_annotation.dart';

part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel{
  const SignUpModel({
    this.avatar,
    required this.email,
    required this.full_name,
    required this.password,
    required this.roleId
  });

  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "full_name")
  final String? full_name;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "roleId")
  final String? roleId;

  factory SignUpModel.fromJson(Map<String, dynamic> json) => _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);

}