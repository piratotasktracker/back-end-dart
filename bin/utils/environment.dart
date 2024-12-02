import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Environment{

  static getDBUri() => (DotEnv()..load()).getOrElse(EnvironmentConstants.dbUri, () => Platform.environment[EnvironmentConstants.dbUri] ?? '');

  static getSecretKey() => (DotEnv()..load()).getOrElse(EnvironmentConstants.jwtSecret, () => Platform.environment[EnvironmentConstants.jwtSecret] ?? '');

  static getDBType() => (DotEnv()..load()).getOrElse(EnvironmentConstants.dbType, () => Platform.environment[EnvironmentConstants.dbType] ?? '');

  static getPostgreURI() => (DotEnv()..load()).getOrElse(EnvironmentConstants.dbType, () => Platform.environment[EnvironmentConstants.dbType] ?? '');

}

class EnvironmentConstants{

  static const String dbUri = "DB_URI";
  static const String jwtSecret = "JWT_SECRET_KEY";
  static const String dbType = "DB_TYPE";

}