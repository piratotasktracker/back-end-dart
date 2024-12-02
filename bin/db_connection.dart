import 'package:mongo_dart/mongo_dart.dart';

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

class PostgreConnection extends DBConnection<void>{
  PostgreConnection();

  @override
  Future<void> initialize({required String connectionString}) async{
    throw UnimplementedError();
  }

  @override
  Future<void> close() async{
    throw UnimplementedError();
  }

  DbCollection get users => throw UnimplementedError();

  DbCollection get projects => throw UnimplementedError();

  DbCollection get tasks => throw UnimplementedError();
  
}



class _Collection{
  static const String users = "users";
  static const String projects = "projects";
  static const String tasks = "tasks";
}