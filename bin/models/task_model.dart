import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';

part 'task_model.g.dart';

abstract class ITaskModel{

  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "projectId")
  final String projectId;
  @JsonKey(name: "createdById")
  final String createdById;
  @JsonKey(name: "assigneeId")
  final String assigneeId;
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
class CreateTaskModel extends ITaskModel{

  const CreateTaskModel({
    required super.name,
    required super.createdById,
    required super.assigneeId,
    required super.projectId,
    this.linkedTasks = const [],
    super.description
  });

  final List<String> linkedTasks;
  
  factory CreateTaskModel.fromJson(Map<String, dynamic> json) => _$CreateTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskModelToJson(this);

  Map<String, dynamic> dbCreate({
    required String createdAt, 
    required String updatedAt,
  }){
    return toJson()..addAll({
      "createdAt": createdAt,
      "updatedAt": updatedAt
    });
  }

  Map<String, dynamic> dbUpdate({
    required String updatedAt,
  }){
    return toJson()..addAll({
      "updatedAt": updatedAt
    });
  }
}

@JsonSerializable()
class TaskDBModel extends ITaskModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "updatedAt")
  final String updatedAt;
  @JsonKey(name: "linkedTasks")
  final List<String> linkedTasks;

  const TaskDBModel({
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

  TaskResponse toTaskResponse(List<ChildTaskResponse> newLinkedTasks){
    return TaskResponse(
      name: name, 
      id: id, 
      linkedTasks: newLinkedTasks,
      description: description, 
      createdAt: createdAt, 
      createdById: createdById,
      assigneeId: assigneeId,
      updatedAt: updatedAt, 
      projectId: projectId
    );
  }

  factory TaskDBModel.fromJson(Map<String, dynamic> json) => _$TaskDBModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDBModelToJson(this);

}

@JsonSerializable()
class TaskResponse extends ITaskModel{
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "updatedAt")
  final String updatedAt;
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
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) => _$TaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);

}

@JsonSerializable()
class ChildTaskResponse extends ITaskModel{
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "updatedAt")
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
