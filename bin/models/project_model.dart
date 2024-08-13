import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../utils/object_id_converter.dart';

part 'project_model.g.dart';

@JsonSerializable()
class DBProjectModel {

  const DBProjectModel({
    required this.name,
    this.description = '',
  });

  final String name;
  final String description;
  
  factory DBProjectModel.fromJson(Map<String, dynamic> json) => _$DBProjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$DBProjectModelToJson(this);

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
    print(toJson()..addAll({
      "updatedAt": updatedAt
    }));
    return toJson()..addAll({
      "updatedAt": updatedAt
    });
  }
}

@JsonSerializable()
class ProjectDBModel{
  @JsonKey(name: '_id')
  @ObjectIdConverter()
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "updatedAt")
  final String updatedAt;

  const ProjectDBModel({
    required this.name,
    required this.id,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  ProjectResponse toProjectResponse(){
    return ProjectResponse(
      name: name, 
      id: id, 
      description: description, 
      createdAt: createdAt, 
      updatedAt: updatedAt, 
    );
  }

  factory ProjectDBModel.fromJson(Map<String, dynamic> json) => _$ProjectDBModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectDBModelToJson(this);

}

@JsonSerializable()
class ProjectResponse{
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "description")
  final String description;
  @JsonKey(name: "createdAt")
  final String createdAt;
  @JsonKey(name: "updatedAt")
  final String updatedAt;

  const ProjectResponse({
    required this.name,
    required this.id,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) => _$ProjectResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectResponseToJson(this);

}
