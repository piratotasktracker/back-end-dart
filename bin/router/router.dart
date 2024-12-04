import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../endpoints/auth/login.dart';
import '../endpoints/auth/sign_up.dart';
import '../endpoints/projects/create_project.dart';
import '../endpoints/projects/delete_project.dart';
import '../endpoints/projects/get_project.dart';
import '../endpoints/projects/get_projects.dart';
import '../endpoints/projects/update_project.dart';
import '../endpoints/tasks/create_task.dart';
import '../endpoints/tasks/delete_task.dart';
import '../endpoints/tasks/get_task.dart';
import '../endpoints/tasks/get_tasks.dart';
import '../endpoints/projects/get_tasks_by_project_id.dart';
import '../endpoints/tasks/update_task.dart';
import '../endpoints/users/get_me.dart';
import '../endpoints/users/get_user.dart';
import '../endpoints/users/get_users.dart';
import '../middlewares/check_authorization.dart';
import '../db_connection.dart';
import '../middlewares/error_middleware.dart';

class CheckIfAlive{

  static Response _rootHandler(Request req, DBConnection connection) {
    return Response.ok('Service alive');
  }

  static Handler handler({required DBConnection connection}) {
    return (Request req) => _rootHandler(req, connection);
  }
}

class AppRouter{

  AppRouter({
    required this.connection
  });
  final DBConnection connection;

  final router = Router();

  void initialize(){

    final authorizedPipeline = Pipeline().addMiddleware(checkAuthorization()).addMiddleware(errorHandlingMiddleware());
    final unauthorizedPipeline = Pipeline().addMiddleware(errorHandlingMiddleware());

    //<protected>

    //user management
    router.get(AppRoutes.users, authorizedPipeline 
      .addHandler(GetUsers().handler(connection: connection)));
    router.get(AppRoutes.user, authorizedPipeline 
      .addHandler(GetUser().handler(connection: connection)));
    router.get(AppRoutes.me, authorizedPipeline 
      .addHandler(GetMe().handler(connection: connection)));

    //project management
    router.post(AppRoutes.projects, authorizedPipeline
      .addHandler(CreateProject().handler(connection: connection)));
    router.get(AppRoutes.projects, authorizedPipeline
      .addHandler(GetProjects().handler(connection: connection)));
    router.get(AppRoutes.project, authorizedPipeline
      .addHandler(GetProject().handler(connection: connection)));
    router.put(AppRoutes.project, authorizedPipeline
      .addHandler(UpdateProject().handler(connection: connection)));
    router.delete(AppRoutes.project, authorizedPipeline
      .addHandler(DeleteProject().handler(connection: connection)));

    //task management
    router.post(AppRoutes.tasks, authorizedPipeline
      .addHandler(CreateTask().handler(connection: connection)));
    router.get(AppRoutes.tasks, authorizedPipeline
      .addHandler(GetTasks().handler(connection: connection)));
    router.get(AppRoutes.task, authorizedPipeline
      .addHandler(GetTask().handler(connection: connection)));
    router.get(AppRoutes.taskByProjectId, authorizedPipeline
      .addHandler(GetTasksByProjectId().handler(connection: connection)));
    router.put(AppRoutes.task, authorizedPipeline
      .addHandler(UpdateTask().handler(connection: connection)));
    router.delete(AppRoutes.task, authorizedPipeline
      .addHandler(DeleteTask().handler(connection: connection)));

    //</protected>
    
    //<public>

    router.get(AppRoutes.checkAlive, unauthorizedPipeline.addHandler(CheckIfAlive.handler(connection: connection)));

    router.post(AppRoutes.login, unauthorizedPipeline.addHandler(Login().handler(connection: connection)));
    router.post(AppRoutes.signUp, unauthorizedPipeline.addHandler(SignUp().handler(connection: connection)));

    //</public>
  }
    
}

class AppRoutes{
  static const String checkAlive = '/';
  static const String users = '/users';
  static const String user = '/users/<id>';
  static const String me = '/me';
  static const String projects = '/projects';
  static const String project = '/projects/<id>';
  static const String task = '/tasks/<id>';
  static const String taskByProjectId = '/projects/<id>/tasks/';
  static const String tasks = '/tasks';
  static const String signUp = '/signUp';
  static const String login = '/login';
}