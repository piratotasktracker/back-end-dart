import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import '../../db_connection.dart';
import '../../models/project_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetProjectRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Map<String, dynamic>? params,
  }) async{
    if(params != null){
      final id = params['id'];
      final PermissionLevel userPermission = PermissionLevel.fromInt(params["permissionLevel"] as int? ?? 0);
      final String? userId = params["userId"] as String?;
      final Map<String, dynamic>? projectRaw;
      if(userPermission.value > 2){
        projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id)));
      }else{
        projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id)).eq('teamMembers', userId)); 
      }
      if (projectRaw == null) {
        return (false, 'Project not found');
      }
      final ProjectDBModel project = ProjectDBModel.fromJson(projectRaw);
      final teamMembersRaw = await connection.users.find(where.oneFrom('_id', project.teamMembers.map((e) => ObjectId.fromHexString(e)).toList())).toList();
      return (true, json.encode(project.toProjectResponse(teamMembersRaw.map((user) => UserDBModel.fromJson(user).toUserResponse()).toList()).toJson()));
    }else{
      return (false, 'Project not found');
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required void credentials, 
    Map<String, dynamic>? params,
  }) {
    throw UnimplementedError();
  }

}