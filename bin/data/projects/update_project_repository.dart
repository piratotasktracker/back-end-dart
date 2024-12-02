import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/project_model.dart';
import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../repository_interface.dart';

class UpdateProjectRepository extends IRepository<DBConnection, ProjectRequest>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required ProjectRequest credentials, 
    Request? params,
  }) async{
    if(params!=null){
      final String now = DateTime.now().toIso8601String();
      var modifier = modify;
      final id = params.params['id'];
      credentials.dbUpdate(updatedAt: now).forEach((key, value) {
        modifier = modifier.set(key, value);
      });
      final result = await connection.projects.updateOne(
        where.eq('_id', ObjectId.fromHexString(id??'')),
        modifier,
      );
      if(result.isSuccess){
        return (true, json.encode(SuccessMessage(result: 'Project ${credentials.name} updated successfully', statusCode: 200).toJson()));
      }else{
        return (false, 'Error updating project');  
      }
    }else{
      return (false, 'Something went wrong');
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