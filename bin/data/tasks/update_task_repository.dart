import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../repository_interface.dart';

class UpdateTaskRepository extends IRepository<DBConnection, TaskRequest>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required TaskRequest credentials, 
    Request? params,
  }) async{
    if(params != null){
      String now = DateTime.now().toIso8601String();
      var modifier = modify;
      final id = params.params['id'];
      credentials.dbUpdate(updatedAt: now).forEach((key, value) {
        modifier = modifier.set(key, value);
      });
      await connection.tasks.updateOne(
        where.eq('_id', ObjectId.fromHexString(id??'')),
        modifier,
      );
      final result = await connection.tasks.insertOne(
        credentials.dbCreate(createdAt: now, updatedAt: now)
      );
      if(result.isSuccess){
        return (true, json.encode(SuccessMessage(result: 'Task ${credentials.name} updated successfully', statusCode: 200).toJson()));
      }else{
        throw FormatException();
      }
    } else{
      throw Exception();
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