import 'package:json_annotation/json_annotation.dart';

part 'result_models.g.dart';

abstract class Result {

  final int statusCode;
  final String result;

  const Result({
    required this.result,
    required this.statusCode
  });

} 


@JsonSerializable()
class ErrorMessage extends Result{
  const ErrorMessage({
    required super.result,
    required super.statusCode
  });

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

}

@JsonSerializable()
class SuccessMessage extends Result{
  const SuccessMessage({
    required super.result,
    required super.statusCode
  });

  factory SuccessMessage.fromJson(Map<String, dynamic> json) => _$SuccessMessageFromJson(json);

  Map<String, dynamic> toJson() => _$SuccessMessageToJson(this);

}