import 'package:json_annotation/json_annotation.dart';

part 'sign_up_model.g.dart';

@JsonSerializable()
class SignUpModel{
  const SignUpModel({
    this.avatar,
    required this.email,
    required this.fullName,
    required this.password,
    required this.role
  });

  @JsonKey(name: "email")
  final String email;
  @JsonKey(name: "avatar")
  final String? avatar;
  @JsonKey(name: "full_name")
  final String? fullName;
  @JsonKey(name: "password")
  final String password;
  @JsonKey(name: "role")
  final int? role;

  factory SignUpModel.fromJson(Map<String, dynamic> json) => _$SignUpModelFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpModelToJson(this);

}