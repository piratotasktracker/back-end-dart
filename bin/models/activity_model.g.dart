// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) =>
    ActivityModel(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$ActivityModelToJson(ActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'userIds': instance.userIds,
      'type': _$ActivityTypeEnumMap[instance.type]!,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.create: 'CREATE',
  ActivityType.update: 'UPDATE',
  ActivityType.delete: 'DELETE',
};
