import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../models/result_models.dart';
import '../../models/task_model.dart';
import '../../mongo_connection.dart';
import '../../utils/environment.dart';
import '../../utils/handler_interface.dart';
import '../../utils/permission_level.dart';

class UpdateTask {
  static IPostHandler call(){
    final String dbType = Environment.getDBType();
    switch (dbType){
      case "MONGODB":{
        return UpdateTaskMongo();
      }
      case "POSTGRESQL":{
        return UpdateTaskProstgre();
      }
      default: throw UnimplementedError();
    }
  }
}

class UpdateTaskMongo implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    try{
      final PermissionLevel userPermission = PermissionLevel.fromInt(req.context["permissionLevel"] as int? ?? 0);
      final String? userId = req.context["userId"] as String?;
      if(userPermission.value < permissionLevel.value || userId == null){
        return Response.forbidden(json.encode(ErrorMessage(result: 'Permission denied', statusCode: 403).toJson()));
      }
      final id = req.params['id'];
      if (id == null) {
        return Response.badRequest(body: json.encode(ErrorMessage(result: 'Id is missing', statusCode: 400).toJson()));
      }
      final credentials = CreateTaskModel.fromJson(json.decode(await req.readAsString()));
      final validation = validate(credentials);
      if(validation.$1){
        final String now = DateTime.now().toIso8601String();
        var modifier = modify;
        credentials.dbUpdate(updatedAt: now).forEach((key, value) {
          modifier = modifier.set(key, value);
        });
        await connection.tasks.updateOne(
          where.eq('_id', ObjectId.fromHexString(id)),
          modifier,
        );
        return Response.ok(json.encode(SuccessMessage(result: 'Task ${credentials.name} updated successfully', statusCode: 200).toJson()));
      }else{
        return Response(validation.$2 != null ? validation.$2!.statusCode : 400, body: validation.$2?.toJson().toString());
      }
    }catch(e){
      return Response.internalServerError(body: json.encode(ErrorMessage(result: 'Error updating project: $e', statusCode: 500).toJson()));
    }
  }

  @override
  Handler handler({required MongoConnection connection}) {
    return (Request req) => rootHandler(req, connection);
  }

  @override
  (bool, ErrorMessage?) validate(data) {
    if (data is CreateTaskModel){
      Map<String, dynamic> messageMap = {};
      if(data.name.isEmpty){
        messageMap["email"] = "Can not be empty or has non E-mail stucture";
      }
      return messageMap.isEmpty ? (true, null) : (false, ErrorMessage(result: messageMap.toString(), statusCode: 400));
    }else{
      return (false, ErrorMessage(result: "Bad request", statusCode: 400));
    }
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}

class UpdateTaskProstgre implements IPostHandler{
  @override
  Future<Response> rootHandler(Request req, MongoConnection connection) async{
    throw UnimplementedError();
  }

  @override
  Handler handler({required MongoConnection connection}) {
    throw UnimplementedError();
  }
  
  @override
  (bool, ErrorMessage?) validate(data) {
    // TODO: implement validate
    throw UnimplementedError();
  }

  @override
  PermissionLevel get permissionLevel => PermissionLevel.executor;
}