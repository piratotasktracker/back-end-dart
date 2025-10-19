import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/result_models.dart';
import '../../models/role_model.dart';
import '../repository_interface.dart';

class UpdateRoleRepository extends IRepository<DBConnection, RoleRequest>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required RoleRequest credentials, 
    Request? params,
    required bool isBypassed,
  }) async{
    if(params!=null){
      final id = params.params['id'];
      print(credentials.toJson());
      var modifier = modify;
      credentials.toJson().forEach((key, value) {
        modifier = modifier.set(key, value);
      });
      final result = await connection.roles.updateOne(
        where.eq('_id', ObjectId.fromHexString(id??'')),
        modifier,
      );
      if(result.isSuccess){
        return (true, json.encode(SuccessMessage(result: 'Role ${credentials.name} updated successfully', statusCode: 200).toJson()));
      }else{
        throw FormatException();  
      }
    }else{
      throw Exception();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection,
    required RoleRequest credentials,
    Request? params,
    required bool isBypassed,
  }) async {
    throw UnimplementedError();
  }
}