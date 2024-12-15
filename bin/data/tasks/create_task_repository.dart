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
      throw FormatException();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection,
    required TaskRequest credentials,
    Request? params,
  }) async {
    final now = DateTime.now().toIso8601String();

    await connection.db.transaction((ctx) async {
      final taskResult = await ctx.query(
        '''
        INSERT INTO tasks (name, description, assignee_id, project_id, created_by_id, created_at, updated_at)
        VALUES (@name, @description, @assigneeId, @projectId, @createdBy, @createdAt, @updatedAt)
        RETURNING id;
        ''',
        substitutionValues: {
          'name': credentials.name,
          'description': credentials.description,
          'assigneeId': credentials.assigneeId,
          'projectId': credentials.projectId,
          'createdBy': credentials.createdById,
          'createdAt': now,
          'updatedAt': now,
        },
      );

      if (taskResult.isEmpty) {
        throw FormatException('Failed to create task');
      }

      final taskId = taskResult.first.toColumnMap()['id'];

      if (credentials.linkedTasks.isNotEmpty) {
        final linkedTaskQueries = credentials.linkedTasks.map((linkedId) {
          return ctx.query(
            '''
            INSERT INTO task_linked_tasks (task_id, linked_task_id)
            VALUES (@taskId, @linkedTaskId);
            ''',
            substitutionValues: {
              'taskId': taskId,
              'linkedTaskId': linkedId,
            },
          );
        });
        await Future.wait(linkedTaskQueries);
      }
    });

    return (true, json.encode(SuccessMessage(
      result: 'Task ${credentials.name} created successfully',
      statusCode: 200,
    )));
  }

}