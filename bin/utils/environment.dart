import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Environment{

  static getMongoURI() => (DotEnv()..load()).getOrElse('MONGO_DB_URI', () => Platform.environment['MONGO_DB_URI'] ?? '');

  static getSecretKey() => (DotEnv()..load()).getOrElse('JWT_SECRET_KEY', () => Platform.environment['JWT_SECRET_KEY'] ?? '');

  static getDBType() => (DotEnv()..load()).getOrElse('DB_TYPE', () => Platform.environment['DB_TYPE'] ?? '');

}