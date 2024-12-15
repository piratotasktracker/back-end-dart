import 'dart:convert';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';

import '../../models/activity_model.dart';
import '../../utils/activity_type.dart';
import '../../utils/permission_level.dart';
import '../handler_interface.dart';

class GetActivities with PermissionCheckMixin {
  Future<Response> rootHandler(Request req, PostgreSQLConnection connection) async {
    try {
      checkPermission(req: req, permissionLevel: permissionLevel);

      final userId = req.context['userId'] as String?;

      final result = await connection.mappedResultsQuery(
        '''
        SELECT id, description, user_ids, type
        FROM activities
        WHERE @userId = ANY(user_ids)
        ''',
        substitutionValues: {
          'userId': userId,
        },
      );

      // Map the database rows to ActivityModel objects
      final activities = result.map((row) {
        final activity = row['activities']; // Extract the nested map
        if (activity != null) {
          return ActivityModel(
            id: activity['id'] as int,
            description: activity['description'] as String,
            userIds: (activity['user_ids'] as List<dynamic>).cast<String>(),
            type: ActivityType.fromString(activity['type'] as String),
          );
        }
        return null; // Handle unexpected null values
      }).where((activity) => activity != null).toList();

      // Convert the list of ActivityModel to JSON
      return Response.ok(
        jsonEncode(activities.map((activity) => activity!.toJson()).toList()),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print(e); // Debugging
      return Response.internalServerError(
        body: jsonEncode({'error': 'Failed to fetch activities'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  }

  Handler handler({required PostgreSQLConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  final PermissionLevel permissionLevel = PermissionLevel.executor;
}
