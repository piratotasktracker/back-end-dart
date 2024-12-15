// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProjectRequest _$ProjectRequestFromJson(Map<String, dynamic> json) =>
    ProjectRequest(
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      teamMembers: (json['teamMembers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProjectRequestToJson(ProjectRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'teamMembers': instance.teamMembers,
    };

ProjectDBMongo _$ProjectDBMongoFromJson(Map<String, dynamic> json) =>
    ProjectDBMongo(
      name: json['name'] as String,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      teamMembers: (json['teamMembers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProjectDBMongoToJson(ProjectDBMongo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      '_id': const ObjectIdConverter().toJson(instance.id),
      'teamMembers': instance.teamMembers,
    };

ProjectDBPostgre _$ProjectDBPostgreFromJson(Map<String, dynamic> json) =>
    ProjectDBPostgre(
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ProjectDBPostgreToJson(ProjectDBPostgre instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'id': instance.id,
    };

ProjectResponse _$ProjectResponseFromJson(Map<String, dynamic> json) =>
    ProjectResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      teamMembers: (json['teamMembers'] as List<dynamic>)
          .map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectResponseToJson(ProjectResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'id': instance.id,
      'teamMembers': instance.teamMembers,
    };
