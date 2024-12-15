import 'package:json_annotation/json_annotation.dart';

import '../utils/activity_type.dart';

part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel {
  final int id;
  final String description;
  final List<String> userIds;
  final ActivityType type;

  const ActivityModel({
    required this.id,
    required this.description,
    required this.userIds,
    required this.type,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
