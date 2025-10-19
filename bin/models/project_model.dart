import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';
import 'user_db_model.dart';

part 'project_model.g.dart';

abstract class IProjectModel{

  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;

  const IProjectModel({
    required this.name,
    this.description = '',
  });
}

abstract class IExtendedProjectModel extends IProjectModel{
  
  @JsonKey(name: "created_at")
  final String createdAt;
  @JsonKey(name: "updated_at")
  final String updatedAt;

  const IExtendedProjectModel({
    required this.createdAt,
    required this.updatedAt,
    required super.name,
    super.description = '',
  });
}


@JsonSerializable()
class ProjectRequest extends IProjectModel{

  const ProjectRequest({
    required super.name,
    super.description,
    required this.teamMembers,
  });

  @JsonKey(name: "teamMembers")
  final List<String> teamMembers;
  
  factory ProjectRequest.fromJson(Map<String, dynamic> json) => _$ProjectRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectRequestToJson(this);

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
class ProjectDBMongo extends IExtendedProjectModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "teamMembers")
  final List<String> teamMembers;

  const ProjectDBMongo({
    required super.name,
    required this.id,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required this.teamMembers,
  });

  ProjectResponse toProjectResponse(List<UserResponse> teamMembers){
    return ProjectResponse(
      name: name, 
      id: id, 
      description: description, 
      createdAt: createdAt, 
      updatedAt: updatedAt, 
      teamMembers: teamMembers,
    );
  }

  factory ProjectDBMongo.fromJson(Map<String, dynamic> json) => _$ProjectDBMongoFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDBMongoToJson(this);

}

@JsonSerializable()
class ProjectDBPostgre extends IExtendedProjectModel{
  final int id;

  const ProjectDBPostgre({
    required super.name,
    required this.id,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
  });

  ProjectResponse toProjectResponse(List<UserResponse> teamMembers){
    return ProjectResponse(
      name: name, 
      id: id.toString(), 
      description: description, 
      createdAt: createdAt, 
      updatedAt: updatedAt, 
      teamMembers: teamMembers,
    );
  }

  factory ProjectDBPostgre.fromJson(Map<String, dynamic> json) => _$ProjectDBPostgreFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDBPostgreToJson(this);

}

@JsonSerializable()
class ProjectResponse extends IExtendedProjectModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "teamMembers")
  final List<UserResponse> teamMembers;

  const ProjectResponse({
    required super.name,
    required this.id,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required this.teamMembers,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) => _$ProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectResponseToJson(this);

}
