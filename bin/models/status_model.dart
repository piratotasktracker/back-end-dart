import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';

part 'status_model.g.dart';

abstract class IStatusModel{

  @JsonKey(name: "name")
  final String name;

  const IStatusModel({
    required this.name
  });

}

@JsonSerializable()
class StatusModel extends IStatusModel {
  @JsonKey(name: "id")
  final String id;

  const StatusModel({required this.id, required super.name});

  factory StatusModel.fromJson(Map<String, dynamic> json) => _$StatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusModelToJson(this);

}

@JsonSerializable()
class StatusDBModel extends IStatusModel {

  @JsonKey(name: "id")
  @ObjectIdConverter()
  final String id; 

  const StatusDBModel({required this.id, required super.name});

  factory StatusDBModel.fromJson(Map<String, dynamic> json) => _$StatusDBModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatusDBModelToJson(this);
}