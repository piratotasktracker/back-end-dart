import 'package:shelf/shelf.dart';

import '../db_connection.dart';
import '../models/result_models.dart';

abstract class IRepository<DBConnection, C> {

  dynamic checkInteractorType({required DBConnection connection, dynamic credentials, Request? params, required isBypassed}) {
    if (credentials is! C) {
      return (
        false,
        ErrorMessage(result: "Service error: Invalid database connection", statusCode: 500)
      );
    }
    return interact(connection: connection, credentials: credentials, params: params, isBypassed: isBypassed);
  }

  Future<(bool, dynamic)> interact({required DBConnection connection, required C credentials, Request? params, required bool isBypassed}){
    if(connection is MongoConnection){
      return interactMongo(connection: connection, credentials: credentials, params: params, isBypassed: isBypassed);
    }else{
      return interactPostgre(connection: connection as PostgreConnection, credentials: credentials, params: params, isBypassed: isBypassed);
    }
  }

  Future<(bool, dynamic)> interactMongo({
    required MongoConnection connection, 
    required C credentials, 
    Request? params,
    required bool isBypassed,
  });

  Future<(bool, dynamic)> interactPostgre({
    required PostgreConnection connection, 
    required C credentials, 
    Request? params,
    required bool isBypassed,
  });

}