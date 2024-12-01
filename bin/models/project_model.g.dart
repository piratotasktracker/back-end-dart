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

ProjectDBModel _$ProjectDBModelFromJson(Map<String, dynamic> json) =>
    ProjectDBModel(
      name: json['name'] as String,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      teamMembers: (json['teamMembers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$ProjectDBModelToJson(ProjectDBModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      '_id': const ObjectIdConverter().toJson(instance.id),
      'teamMembers': instance.teamMembers,
    };

ProjectResponse _$ProjectResponseFromJson(Map<String, dynamic> json) =>
    ProjectResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      teamMembers: (json['teamMembers'] as List<dynamic>)
          .map((e) => UserResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectResponseToJson(ProjectResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'id': instance.id,
      'teamMembers': instance.teamMembers,
    };
