import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../repository_interface.dart';

class DeleteProjectRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
  }) async{
    final result = await connection.projects.deleteOne(where.eq('_id', ObjectId.fromHexString(credentials)));
    if(result.isSuccess){
      return (true, json.encode(SuccessMessage(result: 'Project deleted successfully', statusCode: 200).toJson()));
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
    final projectId = credentials;

    await connection.db.transaction((ctx) async {

      await ctx.query('DELETE FROM project_team_members WHERE project_id = @projectId', substitutionValues: {
        'projectId': projectId,
      });

      final result = await ctx.query('DELETE FROM projects WHERE id = @id', substitutionValues: {
        'id': projectId,
      });

      if (result.affectedRowCount == 0) {
        throw FormatException('Project not found');
      }

      return true;
    });

    return (true, json.encode(SuccessMessage(result: 'Project deleted successfully', statusCode: 200).toJson()));
  }

}