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
import '../mongo_connection.dart';

class CheckIfAlive{

  static Response _rootHandler(Request req, MongoConnection connection) {
    return Response.ok('Sevice alive');
  }

  static Handler handler({required MongoConnection connection}) {
    return (Request req) => _rootHandler(req, connection);
  }
}

class AppRouter{

  AppRouter({
    required this.connection
  });
  final MongoConnection connection;

  final router = Router();

  void initialize(){

    //<protected>

    router.get(AppRoutes.checkAlive, CheckIfAlive.handler(connection: connection));

    //user management
    router.get(AppRoutes.users, Pipeline().addMiddleware(checkAuthorization()) 
      .addHandler(GetUsers.call().handler(connection: connection)));
    router.get(AppRoutes.user, Pipeline().addMiddleware(checkAuthorization()) 
      .addHandler(GetUser.call().handler(connection: connection)));
    router.get(AppRoutes.me, Pipeline().addMiddleware(checkAuthorization()) 
      .addHandler(GetMe.call().handler(connection: connection)));

    //project management
    router.post(AppRoutes.projects, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(CreateProject.call().handler(connection: connection)));
    router.get(AppRoutes.projects, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(GetProjects.call().handler(connection: connection)));
    router.get(AppRoutes.project, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(GetProject.call().handler(connection: connection)));
    router.put(AppRoutes.project, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(UpdateProject.call().handler(connection: connection)));
    router.delete(AppRoutes.project, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(DeleteProject.call().handler(connection: connection)));

    //task management
    router.post(AppRoutes.tasks, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(CreateTask.call().handler(connection: connection)));
    router.get(AppRoutes.tasks, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(GetTasks.call().handler(connection: connection)));
    router.get(AppRoutes.task, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(GetTask.call().handler(connection: connection)));
    router.get(AppRoutes.taskByProjectId, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(GetTasksByProjectId.call().handler(connection: connection)));
    router.put(AppRoutes.task, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(UpdateTask.call().handler(connection: connection)));
    router.delete(AppRoutes.task, Pipeline().addMiddleware(checkAuthorization())
      .addHandler(DeleteTask.call().handler(connection: connection)));

    //</protected>
    
    //<public>

    router.post(AppRoutes.login, Login.call().handler(connection: connection));
    router.post(AppRoutes.signUp, SignUp.call().handler(connection: connection));

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