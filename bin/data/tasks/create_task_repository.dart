import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../repository_interface.dart';

class CreateTaskRepository extends IRepository<DBConnection, TaskRequest>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required TaskRequest credentials, 
    Request? params,
  }) async{
    String now = DateTime.now().toIso8601String();
    final result = await connection.tasks.insertOne(
      credentials.dbCreate(createdAt: now, updatedAt: now)
    );
    if(result.isSuccess){
      return (true, json.encode(SuccessMessage(result: 'Task ${credentials.name} created successfully', statusCode: 200)));
    }else{
      return (false, 'Error creating task');  
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required TaskRequest credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}