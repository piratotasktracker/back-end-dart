import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../../utils/error_handler.dart';
import '../repository_interface.dart';

class DeleteRoleRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Request? params,
    required bool isBypassed,
  }) async{
    final role = await connection.tasks.findOne(where
      .eq('_id', ObjectId.fromHexString(credentials))
    );
    if(role == null){
      throw NotFoundException();
    }
    final result = await connection.roles.deleteOne(where.eq('_id', ObjectId.fromHexString(credentials)));
    
    if(result.isSuccess){
      return (true, json.encode(SuccessMessage(result: 'Role deleted successfully', statusCode: 200).toJson()));
    }else{
      throw FormatException();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required String credentials, 
    Request? params,
    required bool isBypassed,
  }) async {
    throw UnimplementedError();
  }

}