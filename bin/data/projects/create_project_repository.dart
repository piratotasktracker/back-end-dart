import '../../models/project_model.dart';
import '../../db_connection.dart';
import '../repository_interface.dart';

class CreateProjectRepository extends IRepository<DBConnection, ProjectRequest>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required ProjectRequest credentials, 
    Map<String, dynamic>? params,
  }) async{
    String now = DateTime.now().toIso8601String();
    final result = await connection.projects.insertOne(
      credentials.dbCreate(createdAt: now, updatedAt: now)
    );
    if(result.isSuccess){
      return (true, 'Project ${credentials.name} created successfully');
    }else{
      return (false, 'Error creating project');  
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required ProjectRequest credentials, 
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

}