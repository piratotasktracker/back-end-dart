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
  
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "updatedAt")
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
class ProjectDBModel extends IExtendedProjectModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "teamMembers")
  final List<String> teamMembers;

  const ProjectDBModel({
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

  factory ProjectDBModel.fromJson(Map<String, dynamic> json) => _$ProjectDBModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDBModelToJson(this);

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
