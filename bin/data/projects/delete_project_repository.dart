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
  }) {
    throw UnimplementedError();
  }

}