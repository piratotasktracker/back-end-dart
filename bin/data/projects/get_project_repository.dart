import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../db_connection.dart';
import '../../models/project_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
import '../../utils/permission_level.dart';
import '../repository_interface.dart';

class GetProjectRepository extends IRepository<DBConnection, void>{
  
  @override
  Future<(bool, String)> interactMongo({
    required MongoConnection connection, 
    required void credentials, 
    Request? params,
  }) async{
    if(params != null){
      final id = params.params['id'];
      final PermissionLevel userPermission = PermissionLevel.fromInt(params.context["permissionLevel"] as int? ?? 0);
      final String? userId = params.context["userId"] as String?;
      final Map<String, dynamic>? projectRaw;
      if(userPermission.value > 2){
        projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id??'')));
      }else{
        projectRaw = await connection.projects.findOne(where.eq('_id', ObjectId.fromHexString(id??'')).eq('teamMembers', userId)); 
      }
      if (projectRaw == null) {
        throw NotFoundException();
      }
      final ProjectDBMongo project = ProjectDBMongo.fromJson(projectRaw);
      final teamMembersRaw = await connection.users.find(where.oneFrom('_id', project.teamMembers.map((e) => ObjectId.fromHexString(e)).toList())).toList();
      return (true, json.encode(project.toProjectResponse(teamMembersRaw.map((user) => UserDBMongo.fromJson(user).toUserResponse()).toList()).toJson()));
    }else{
      throw NotFoundException();
    }
  }
  
  @override
  Future<(bool, String)> interactPostgre({
    required PostgreConnection connection,
    required void credentials,
    Request? params,
  }) async {
    if (params != null) {
      final id = params.params['id'];
      final PermissionLevel userPermission =
          PermissionLevel.fromInt(params.context["permissionLevel"] as int? ?? 0);
      final String? userId = params.context["userId"] as String?;
      
      String query = '''
        SELECT p.*, u.*
        FROM projects p
        LEFT JOIN project_team_members pu ON p.id = pu.project_id
        LEFT JOIN users u ON pu.user_id = u.id
        WHERE p.id = @id
      ''';

      if (userPermission.value <= 2) {
        query += ' AND pu.user_id = @userId';
      }

      final result = await connection.db.query(query, substitutionValues: {
        'id': id,
        'userId': userId,
      });

      if (result.isEmpty) {
        throw NotFoundException();
      }

      final projectData = result.first;
      final projectJson = Map<String, dynamic>.from(projectData.toColumnMap());

      String createdAtStr = (projectJson['created_at'] as DateTime).toIso8601String();
      String updatedAtStr = (projectJson['updated_at'] as DateTime).toIso8601String();

      projectJson['created_at'] = createdAtStr;
      projectJson['updated_at'] = updatedAtStr;

      final project = ProjectDBPostgre.fromJson(projectJson);

      final teamMembers = result.map((row) {
        final userJson = Map<String, dynamic>.from(row.toColumnMap());
        return UserDBPostgre.fromJson(userJson);
      }).toList();

      return (true, json.encode(
          project.toProjectResponse(teamMembers.map((e) => e.toUserResponse()).toList()).toJson()));
    } else {
      throw NotFoundException();
    }
  }

}