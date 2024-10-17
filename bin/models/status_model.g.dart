// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusModel _$StatusModelFromJson(Map<String, dynamic> json) => StatusModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$StatusModelToJson(StatusModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };

StatusDBModel _$StatusDBModelFromJson(Map<String, dynamic> json) =>
    StatusDBModel(
      id: const ObjectIdConverter().fromJson(json['id'] as ObjectId),
      name: json['name'] as String,
    );

Map<String, dynamic> _$StatusDBModelToJson(StatusDBModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': const ObjectIdConverter().toJson(instance.id),
    };
