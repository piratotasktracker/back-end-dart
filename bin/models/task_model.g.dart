// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskModel _$CreateTaskModelFromJson(Map<String, dynamic> json) =>
    CreateTaskModel(
      name: json['name'] as String,
      createdById: json['createdById'] as String,
      assigneeId: json['assigneeId'] as String,
      projectId: json['projectId'] as String,
      linkedTasks: (json['linkedTasks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$CreateTaskModelToJson(CreateTaskModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      'linkedTasks': instance.linkedTasks,
    };

TaskDBModel _$TaskDBModelFromJson(Map<String, dynamic> json) => TaskDBModel(
      name: json['name'] as String,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      projectId: json['projectId'] as String,
      description: json['description'] as String? ?? '',
      assigneeId: json['assigneeId'] as String,
      linkedTasks: (json['linkedTasks'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdById: json['createdById'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$TaskDBModelToJson(TaskDBModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      '_id': const ObjectIdConverter().toJson(instance.id),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'linkedTasks': instance.linkedTasks,
    };

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      description: json['description'] as String? ?? '',
      linkedTasks: (json['linkedTasks'] as List<dynamic>)
          .map((e) => ChildTaskResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      createdById: json['createdById'] as String,
      assigneeId: json['assigneeId'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'linkedTasks': instance.linkedTasks,
    };

ChildTaskResponse _$ChildTaskResponseFromJson(Map<String, dynamic> json) =>
    ChildTaskResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] as String,
      createdById: json['createdById'] as String,
      assigneeId: json['assigneeId'] as String,
      updatedAt: json['updatedAt'] as String,
      projectId: json['projectId'] as String,
    );

Map<String, dynamic> _$ChildTaskResponseToJson(ChildTaskResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
