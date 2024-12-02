import '../db_connection.dart';
import '../models/result_models.dart';

abstract class IRepository<DBConnection, C> {

  dynamic checkInteractorType({required DBConnection connection, dynamic credentials, Map<String, dynamic>? params}) {
    if (credentials is! C) {
      return (
        false,
        ErrorMessage(result: "Service error: Invalid database connection", statusCode: 500)
      );
    }
    return interact(connection: connection, credentials: credentials);
  }

  Future<(bool, dynamic)> interact({required DBConnection connection, required C credentials, Map<String, dynamic>? params}){
    if(connection is MongoConnection){
      return interactMongo(connection: connection, credentials: credentials);
    }else{
      return interactPostgre(connection: connection as PostgreConnection, credentials: credentials);
    }
  }

  Future<(bool, dynamic)> interactMongo({
    required MongoConnection connection, 
    required C credentials, 
    Map<String, dynamic>? params,
  });

  Future<(bool, dynamic)> interactPostgre({
    required PostgreConnection connection, 
    required C credentials, 
    Map<String, dynamic>? params
  });

}