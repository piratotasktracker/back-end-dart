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
  }) async {
    if (params != null) {
      try {
        final String now = DateTime.now().toIso8601String();
        final id = params.params['id'];

        if (id == null) {
          throw FormatException('Task ID is required to update a task.');
        }

        final query = '''
          UPDATE tasks
          SET name = @name,
              description = @description,
              project_id = @projectId,
              created_by_id = @createdById,
              assignee_id = @assigneeId,
              updated_at = @updatedAt
          WHERE id = @id
          RETURNING id;
        ''';

        final result = await connection.db.query(query, substitutionValues: {
          'id': int.parse(id),
          'name': credentials.name,
          'description': credentials.description,
          'projectId': int.parse(credentials.projectId),
          'createdById': int.parse(credentials.createdById),
          'assigneeId': credentials.assigneeId != null ? int.parse(credentials.assigneeId!) : null,
          'updatedAt': now,
        });

        if (result.isEmpty) {
          throw FormatException('Task with ID $id not found or not updated.');
        }

        final taskId = result.first.toColumnMap()['id'].toString();
        return (true, json.encode(SuccessMessage(result: 'Task ${credentials.name} updated successfully with ID $taskId', statusCode: 200).toJson()));
      } catch (e) {
        throw FormatException('Error updating task: $e');
      }
    } else {
      throw FormatException('Parameters are required for updating a task.');
    }
  }


}