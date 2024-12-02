import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/task_model.dart';
import '../repository_interface.dart';


//TODO: apply permissions
class GetTasksRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    final projectsRaw = await connection.tasks.find().toList();
    final users = projectsRaw.map((user) => TaskDBModel.fromJson(user)).toList();
    return (true, json.encode(users.map((user) => user.toTaskResponse([]).toJson()).toList()));
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