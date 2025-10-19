import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/role_model.dart';
import '../repository_interface.dart';

class GetRolesRepository extends IRepository<DBConnection, void> {

  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
    required bool isBypassed,
  }) async{
    final result = await connection.roles.find().toList();
    if(result.isNotEmpty){
      return (true, json.encode(result.map((project) => RoleMongoModel.fromJson(project).toRoleResponse()).toList()));
    }else{
      throw FormatException(); 
    }
  }

  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required void credentials, 
    Request? params,
    required bool isBypassed,
  }){
    throw UnimplementedError();
  }
  
} 