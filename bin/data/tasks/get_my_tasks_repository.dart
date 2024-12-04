import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../repository_interface.dart';

class GetMyTasksRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    if(params != null){
      final String? userId = params.context["userId"] as String?;
      final projectsRaw = await connection.tasks.find(where.eq("assigneeId", userId).eq("createdById", userId)).toList();
      final users = projectsRaw.map((user) => TaskDBModel.fromJson(user)).toList();
      return (true, json.encode(users.map((user) => user.toTaskResponse([]).toJson()).toList()));
    }else{
      throw Exception();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required void credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}