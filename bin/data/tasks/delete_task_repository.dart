import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../repository_interface.dart';

class DeleteTaskRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    final result = await connection.tasks.deleteOne(where.eq('_id', ObjectId.fromHexString(credentials)));
    if(result.isSuccess){
      return (true, json.encode(SuccessMessage(result: 'Task deleted successfully', statusCode: 200).toJson()));
    }else{
      throw FormatException();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection,
    required String credentials,
    Request? params,
  }) async {
    await connection.db.transaction((ctx) async {
      await ctx.query(
        '''
        DELETE FROM task_linked_tasks 
        WHERE task_id = @taskId OR linked_task_id = @taskId;
        ''',
        substitutionValues: {'taskId': credentials},
      );

      final taskResult = await ctx.query(
        '''
        DELETE FROM tasks WHERE id = @taskId RETURNING id;
        ''',
        substitutionValues: {'taskId': credentials},
      );

      if (taskResult.isEmpty) {
        throw FormatException('Failed to delete task');
      }
    });

    return (true, json.encode(SuccessMessage(
      result: 'Task deleted successfully',
      statusCode: 200,
    )));
  }


}