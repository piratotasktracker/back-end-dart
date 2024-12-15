import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/project_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetProjectsRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    print(params.runtimeType);
    if(params != null){
      final PermissionLevel userPermission = PermissionLevel.fromInt(params.context["permissionLevel"] as int? ?? 0);
      final String? userId = params.context["userId"] as String?;
      final List<Map<String, dynamic>> projectsRaw;
      if(userPermission.value > 2){
        projectsRaw = await connection.projects.find().toList();
      }else{
        projectsRaw = await connection.projects.find(where.eq("teamMembers", userId)).toList();
      }
      final projects = projectsRaw.map((project) => ProjectDBMongo.fromJson(project)).toList();
      final List<ProjectResponse> result = [];
      for(var item in projects){
        final teamMembersRaw = await connection.users.find(where.oneFrom('_id', item.teamMembers.map((e) => ObjectId.fromHexString(e)).toList())).toList();
        result.add(item.toProjectResponse(teamMembersRaw.map((user) => UserDBMongo.fromJson(user).toUserResponse()).toList()));
      }
      return (true, json.encode(result));
    }else{
      throw Exception();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection, 
    required void credentials, 
    Request? params,
  }) {
    throw UnimplementedError();
  }

}