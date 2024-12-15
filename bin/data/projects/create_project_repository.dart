import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../models/project_model.dart';
import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../repository_interface.dart';

class CreateProjectRepository extends IRepository<DBConnection, ProjectRequest>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required ProjectRequest credentials, 
    Request? params,
  }) async{
    String now = DateTime.now().toIso8601String();
    final result = await connection.projects.insertOne(
      credentials.dbCreate(createdAt: now, updatedAt: now)
    );
    if(result.isSuccess){
      return (true, json.encode(SuccessMessage(result: 'Project ${credentials.name} created successfully', statusCode: 200)));
    }else{
      throw FormatException(); 
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required ProjectRequest credentials, 
    Request? params,
  }) async {
    String now = DateTime.now().toIso8601String();
    
    try {
      final result = await connection.db.query(
        'INSERT INTO projects (name, description, created_at, updated_at) '
        'VALUES (@name, @description, @created_at, @updated_at) RETURNING id',
        substitutionValues: {
          'name': credentials.name,
          'description': credentials.description,
          'created_at': now,
          'updated_at': now,
        },
      );
      
      if (result.isNotEmpty) {
        final projectId = result.first[0] as int; 
        
        for (var userId in credentials.teamMembers) {
          await connection.db.query(
            'INSERT INTO project_team_members (project_id, user_id) VALUES (@projectId, @userId)',
            substitutionValues: {
              'projectId': projectId,
              'userId': int.tryParse(userId),
            },
          );
        }
        
        return (true, json.encode(SuccessMessage(result: 'Project ${credentials.name} created successfully with ID: $projectId', statusCode: 200)));
      } else {
        throw FormatException('Failed to create project');
      }
    } catch (e) {
      throw FormatException('Error while creating project: $e');
    }
  }

}