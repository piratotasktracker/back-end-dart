import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

import '../../db_connection.dart';
import '../../models/project_model.dart';
import '../../models/user_db_model.dart';
import '../../utils/error_handler.dart';
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
  }) async {
    if (params != null) {
      final PermissionLevel userPermission = PermissionLevel.fromInt(params.context["permissionLevel"] as int? ?? 0);
      final String? userId = params.context["userId"] as String?;

      String query = '''
        SELECT 
          p.id AS project_id, 
          p.name AS project_name, 
          p.description AS project_description, 
          p.created_at AS project_created_at, 
          p.updated_at AS project_updated_at,
          u.id AS user_id,
          u.email AS user_email,
          u.full_name AS user_full_name,
          u.password AS user_password,
          u.avatar AS user_avatar,
          u.role AS user_role
        FROM projects p
        LEFT JOIN project_team_members ptm ON p.id = ptm.project_id
        LEFT JOIN users u ON ptm.user_id = u.id
      ''';

      if (userPermission.value <= 2) {
        query += ' WHERE ptm.user_id = @userId';
      }

      final result = await connection.db.query(query, substitutionValues: {
        'userId': userId,
      });

      if (result.isEmpty) {
        throw NotFoundException();
      }

      final Map<int, Map<String, dynamic>> projectMap = {};
      final Map<int, List<Map<String, dynamic>>> teamMembersMap = {};
      for (var row in result) {
        final projectId = row.toColumnMap()['project_id'] as int;

        projectMap.putIfAbsent(projectId, () {
          return {
            'id': projectId,
            'name': row.toColumnMap()['project_name'] as String,
            'description': row.toColumnMap()['project_description'] as String?,
            'created_at': (row.toColumnMap()['project_created_at'] as DateTime).toIso8601String(),
            'updated_at': (row.toColumnMap()['project_updated_at'] as DateTime).toIso8601String(),
          };
        });
        if (!teamMembersMap.containsKey(projectId)) {
          teamMembersMap[projectId] = [];
        }
        final userId = row.toColumnMap()['user_id'] as int?;
        if (userId != null) {
          teamMembersMap[projectId]!.add({
            'id': userId,
            'email': row.toColumnMap()['user_email'],
            'full_name': row.toColumnMap()['user_full_name'],
            'avatar': row.toColumnMap()['user_avatar'],
            'role': row.toColumnMap()['user_role'],
            'password': row.toColumnMap()['user_password'],
          });
        }
      }
      final List<ProjectResponse> projects = projectMap.values.map((projectJson) {
        final projectId = projectJson['id'];
        final teamMembersJson = teamMembersMap[projectId] ?? [];
        final teamMembers = teamMembersJson.map((userJson) {
          return UserDBPostgre.fromJson(userJson).toUserResponse();
        }).toList();
        return ProjectResponse(
          id: projectJson['id'].toString(),
          name: projectJson['name'],
          description: projectJson['description'],
          createdAt: projectJson['created_at'],
          updatedAt: projectJson['updated_at'],
          teamMembers: teamMembers,
        );
      }).toList();
      return (true, json.encode(projects.map((e) => e.toJson()).toList()));
    } else {
      throw NotFoundException();
    }
  }



}