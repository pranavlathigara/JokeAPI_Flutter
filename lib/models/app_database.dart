

import 'package:floor/floor.dart';
import 'dart:async';
import 'package:flutter_pip/models/JokesResponse.dart';
import 'package:flutter_pip/models/floor_dao.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
part 'app_database.g.dart';

@Database(version: 1, entities: [JokItem])
abstract class AppDatabase extends FloorDatabase {
  JokeDao get jokeDao;
}