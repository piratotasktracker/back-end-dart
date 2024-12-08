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
  }) {
    throw UnimplementedError();
  }

}