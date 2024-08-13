import 'package:json_annotation/json_annotation.dart';

part 'result_models.g.dart';

@JsonSerializable()
class ErrorMessage{
  const ErrorMessage({
    required this.message,
    required this.statusCode
  });

  final int statusCode;
  final String message;

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

}

@JsonSerializable()
class SuccessMessage{
  const SuccessMessage({
    required this.result,
    required this.statusCode
  });

  final int statusCode;
  final String result;

  factory SuccessMessage.fromJson(Map<String, dynamic> json) => _$SuccessMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessMessageToJson(this);

}