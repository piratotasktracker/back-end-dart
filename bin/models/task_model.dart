import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';
import 'user_db_model.dart';

part 'task_model.g.dart';

abstract class ITaskModel{

  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "projectId")
  final String projectId;
  @JsonKey(name: "createdById")
  final String createdById;
  @JsonKey(name: "assigneeId")
  final String? assigneeId;
  @JsonKey(name: "description")
  final String description;

  const ITaskModel({
    required this.name,
    required this.createdById,
    required this.projectId,
    required this.assigneeId,
    this.description = '',
  });

}

@JsonSerializable()
class TaskRequest extends ITaskModel{

  const TaskRequest({
    required super.name,
    required super.createdById,
    required super.assigneeId,
    required super.projectId,
    this.linkedTasks = const [],
    super.description
  });

  final List<String> linkedTasks;
  
  factory TaskRequest.fromJson(Map<String, dynamic> json) => _$TaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TaskRequestToJson(this);

  Map<String, dynamic> dbCreate({
    required String createdAt, 
    required String updatedAt,
  }){
    return toJson()..addAll({
      "created_at": createdAt,
      "updated_at": updatedAt
    });
  }

  Map<String, dynamic> dbUpdate({
    required String updatedAt,
  }){
    return toJson()..addAll({
      "updated_at": updatedAt
    });
  }
}

@JsonSerializable()
class TaskDBMongo extends ITaskModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "updated_at")
  final String updatedAt;
  @JsonKey(name: "linkedTasks")
  final List<String> linkedTasks;

  const TaskDBMongo({
    required super.name,
    required this.id,
    required super.projectId,
    required super.description,
    required super.assigneeId,
    required this.linkedTasks,
    required super.createdById,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskResponse toTaskResponse({
    required List<ChildTaskResponse> newLinkedTasks, 
    UserResponse? assignee,
    required UserResponse createdBy,
  }){
    return TaskResponse(
      name: name, 
      id: id, 
      linkedTasks: newLinkedTasks,
      description: description, 
      createdAt: createdAt, 
      createdById: createdById,
      assigneeId: assigneeId,
      updatedAt: updatedAt, 
      projectId: projectId,
      assignee: assignee,
      createdBy: createdBy,
    );
  }

  factory TaskDBMongo.fromJson(Map<String, dynamic> json) => _$TaskDBMongoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDBMongoToJson(this);

}

@JsonSerializable()
class TaskDBPostgre extends ITaskModel{
  final int id;
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "updated_at")
  final String updatedAt;

  const TaskDBPostgre({
    required super.name,
    required this.id,
    required super.projectId,
    required super.description,
    required super.assigneeId,
    required super.createdById,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskResponse toTaskResponse({
    required List<ChildTaskResponse> newLinkedTasks, 
    UserResponse? assignee,
    required UserResponse createdBy,
  }){
    return TaskResponse(
      name: name, 
      id: id.toString(), 
      linkedTasks: newLinkedTasks,
      description: description, 
      createdAt: createdAt, 
      createdById: createdById,
      assigneeId: assigneeId,
      updatedAt: updatedAt, 
      projectId: projectId,
      assignee: assignee,
      createdBy: createdBy,
    );
  }

  factory TaskDBPostgre.fromJson(Map<String, dynamic> json) => _$TaskDBPostgreFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDBPostgreToJson(this);

}

@JsonSerializable()
class TaskResponse extends ITaskModel{
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "updated_at")
  final String updatedAt;
  @JsonKey(name: "assignee")
  final UserResponse? assignee;
  @JsonKey(name: "createdBy")
  final UserResponse createdBy;
  @JsonKey(name: "linkedTasks")
  final List<ChildTaskResponse> linkedTasks;

  const TaskResponse({
    required super.name,
    required this.id,
    required super.projectId,
    required super.description,
    required this.linkedTasks,
    required this.createdAt,
    required super.createdById,
    required super.assigneeId,
    required this.updatedAt,
    this.assignee,
    required this.createdBy
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) => _$TaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);

}

@JsonSerializable()
class ChildTaskResponse extends ITaskModel{
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "updated_at")
  final String updatedAt;

  const ChildTaskResponse({
    required super.name,
    required this.id,
    required super.description,
    required this.createdAt,
    required super.createdById,
    required super.assigneeId,
    required this.updatedAt,
    required super.projectId,
  });

  factory ChildTaskResponse.fromJson(Map<String, dynamic> json) => _$ChildTaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChildTaskResponseToJson(this);

}
