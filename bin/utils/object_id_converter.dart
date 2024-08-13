import 'package:json_annotation/json_annotation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ObjectIdConverter implements JsonConverter<String, ObjectId> {
  const ObjectIdConverter();

  @override
  String fromJson(ObjectId id) => id.oid;
  

  @override
  ObjectId toJson(String object) => ObjectId.fromHexString(object);
}