import 'package:mongo_dart/mongo_dart.dart';
import 'package:postgres/postgres.dart';

abstract class DBConnection<T>{
  
  late T db;
  
  Future<void> initialize({required String connectionString}) async{}

  Future<void> close() async{}

}

class MongoConnection extends DBConnection<Db>{
  MongoConnection();

  @override
  Future<void> initialize({required String connectionString}) async{
    db = Db(connectionString);
    await db.open();
  }

  @override
  Future<void> close() async{
    await db.close();
  }

  DbCollection get users => db.collection(_Collection.users);

  DbCollection get projects => db.collection(_Collection.projects);

  DbCollection get tasks => db.collection(_Collection.tasks);
  
}

class PostgreConnection extends DBConnection<PostgreSQLConnection>{
  PostgreConnection();

  @override
  Future<void> initialize({required String connectionString}) async {
    final uri = Uri.parse(connectionString);

    db = PostgreSQLConnection(
      uri.host,
      uri.port,
      uri.pathSegments.first, // Database name
      username: uri.userInfo.split(':').first,
      password: uri.userInfo.split(':').last,
    );
    await db.open();
  }

  @override
  Future<void> close() async {
    await db.close();
  }
  
}



class _Collection{
  static const String users = "users";
  static const String projects = "projects";
  static const String tasks = "tasks";
}