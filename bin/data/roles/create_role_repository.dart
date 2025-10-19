import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../../models/role_model.dart';
import '../repository_interface.dart';

class CreateRoleRepository extends IRepository<DBConnection, RoleRequest> {

  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required RoleRequest credentials, 
    Request? params,
    required bool isBypassed,
  }) async{
    final result = await connection.roles.insertOne(
      credentials.toJson()
    );
    if(result.isSuccess){
      return (true, json.encode(SuccessMessage(result: 'Role ${credentials.name} created successfully', statusCode: 200)));
    }else{
      throw FormatException(); 
    }
  }

  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required RoleRequest credentials, 
    Request? params,
    required bool isBypassed,
  }){
    throw UnimplementedError();
  }
  
} 