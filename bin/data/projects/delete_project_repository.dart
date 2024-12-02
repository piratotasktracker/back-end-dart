import 'package:mongo_dart/mongo_dart.dart';

import '../../db_connection.dart';
import '../repository_interface.dart';

class DeleteProjectRepository extends IRepository<DBConnection, String>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required String credentials, 
    Map<String, dynamic>? params,
  }) async{
    final result = await connection.projects.deleteOne(where.eq('_id', ObjectId.fromHexString(credentials)));
    if(result.isSuccess){
      return (true, 'Project deleted successfully');
    }else{
      return (false, 'Error deleting project');  
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required String credentials, 
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

}