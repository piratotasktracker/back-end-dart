// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskRequest _$TaskRequestFromJson(Map<String, dynamic> json) => TaskRequest(
      name: json['name'] as String,
      createdById: json['createdById'] as String,
      assigneeId: json['assigneeId'] as String?,
      projectId: json['projectId'] as String,
      linkedTasks: (json['linkedTasks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$TaskRequestToJson(TaskRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      'linkedTasks': instance.linkedTasks,
    };

TaskDBMongo _$TaskDBMongoFromJson(Map<String, dynamic> json) => TaskDBMongo(
      name: json['name'] as String,
      id: const ObjectIdConverter().fromJson(json['_id'] as ObjectId),
      projectId: json['projectId'] as String,
      description: json['description'] as String? ?? '',
      assigneeId: json['assigneeId'] as String?,
      linkedTasks: (json['linkedTasks'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdById: json['createdById'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$TaskDBMongoToJson(TaskDBMongo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      '_id': const ObjectIdConverter().toJson(instance.id),
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'linkedTasks': instance.linkedTasks,
    };

TaskDBPostgre _$TaskDBPostgreFromJson(Map<String, dynamic> json) =>
    TaskDBPostgre(
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      projectId: json['projectId'] as String,
      description: json['description'] as String? ?? '',
      assigneeId: json['assigneeId'] as String?,
      createdById: json['createdById'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$TaskDBPostgreToJson(TaskDBPostgre instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

TaskResponse _$TaskResponseFromJson(Map<String, dynamic> json) => TaskResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      description: json['description'] as String? ?? '',
      linkedTasks: (json['linkedTasks'] as List<dynamic>)
          .map((e) => ChildTaskResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      createdById: json['createdById'] as String,
      assigneeId: json['assigneeId'] as String?,
      updatedAt: json['updated_at'] as String,
      assignee: json['assignee'] == null
          ? null
          : UserResponse.fromJson(json['assignee'] as Map<String, dynamic>),
      createdBy:
          UserResponse.fromJson(json['createdBy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TaskResponseToJson(TaskResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'projectId': instance.projectId,
      'createdById': instance.createdById,
      'assigneeId': instance.assigneeId,
      'description': instance.description,
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'assignee': instance.assignee,
      'createdBy': instance.createdBy,
      'linkedTasks': instance.linkedTasks,
    };

ChildTaskResponse _$ChildTaskResponseFromJson(Map<String, dynamic> json) =>
    ChildTaskResponse(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String,
      createdById: json['createdById'] as String,
      assigneeId: json['assigneeId'] as String?,
      updatedAt: json['updated_at'] as String,
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
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
