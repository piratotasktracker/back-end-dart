import 'package:json_annotation/json_annotation.dart';

enum PermissionLevel{
  @JsonValue(0)
  unknown(0),
  @JsonValue(1)
  executor(1),
  @JsonValue(2)
  manager(2),
  @JsonValue(3)
  administrator(3),
  @JsonValue(4)
  owner(4);

  const PermissionLevel(this.value);
  
  final int value;

  static PermissionLevel fromInt(int value) {
    switch (value){
      case 0: return PermissionLevel.unknown; 
      case 1: return PermissionLevel.executor;
      case 2: return PermissionLevel.manager;
      case 3: return PermissionLevel.administrator;
      case 4: return PermissionLevel.owner;
      default: return PermissionLevel.unknown;
    }
  }
}