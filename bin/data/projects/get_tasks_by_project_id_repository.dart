import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetTasksByProjectIdRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    if(params != null){
      final List<Map<String, dynamic>> tasksRaw;
      final id = params.params['id'];
      final String? userId = params.context["userId"] as String?;
      final PermissionLevel userPermission = PermissionLevel.fromInt(params.context["permissionLevel"] as int? ?? 0);
      if(userPermission.value > 2){
        tasksRaw = await connection.tasks.find(where.eq("projectId", id)).toList();
      }else{
        tasksRaw = await connection.tasks.find(where.eq("projectId", id).eq("teamMembers", userId)).toList();
      }
      final projects = tasksRaw.map((user) => TaskDBModel.fromJson(user)).toList();
      return (true, json.encode(projects.map((user) => user.toTaskResponse([]).toJson()).toList()));
    }else{
      throw Exception();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required String credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}