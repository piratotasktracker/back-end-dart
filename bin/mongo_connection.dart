import 'package:mongo_dart/mongo_dart.dart';

class MongoConnection{
  MongoConnection();

  late Db db;

  Future<void> initialize({required String connectionString}) async{
    db = Db(connectionString);
    await db.open();
  }

  Future<void> close() async{
    await db.close();
  }

  DbCollection get users => db.collection(_Collection.users);

  DbCollection get projects => db.collection(_Collection.projects);

  DbCollection get tasks => db.collection(_Collection.tasks);
  
}

class _Collection{
  static const String users = "users";
  static const String projects = "projects";
  static const String tasks = "tasks";
}