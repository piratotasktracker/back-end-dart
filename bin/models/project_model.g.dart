// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DBProjectModel _$DBProjectModelFromJson(Map<String, dynamic> json) =>
    DBProjectModel(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$DBProjectModelToJson(DBProjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

ProjectDBModel _$ProjectDBModelFromJson(Map<String, dynamic> json) =>
    ProjectDBModel(
      name: json['name'] as String,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$ProjectDBModelToJson(ProjectDBModel instance) =>
    <String, dynamic>{
      '_id': const ObjectIdConverter().toJson(instance.id),
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

ProjectResponse _$ProjectResponseFromJson(Map<String, dynamic> json) =>
    ProjectResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$ProjectResponseToJson(ProjectResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
