import 'package:shelf/shelf.dart';

import '../db_connection.dart';
import '../models/result_models.dart';

abstract class IRepository<DBConnection, C> {

  dynamic checkInteractorType({required DBConnection connection, dynamic credentials, Request? params}) {
    if (credentials is! C) {
      return (
        false,
        ErrorMessage(result: "Service error: Invalid database connection", statusCode: 500)
      );
    }
    return interact(connection: connection, credentials: credentials, params: params);
  }

  Future<(bool, dynamic)> interact({required DBConnection connection, required C credentials, Request? params}){
    if(connection is MongoConnection){
      return interactMongo(connection: connection, credentials: credentials, params: params);
    }else{
      return interactPostgre(connection: connection as PostgreConnection, credentials: credentials, params: params);
    }
  }

  Future<(bool, dynamic)> interactMongo({
    required MongoConnection connection, 
    required C credentials, 
    Request? params,
  });

  Future<(bool, dynamic)> interactPostgre({
    required PostgreConnection connection, 
    required C credentials, 
    Request? params
  });

}