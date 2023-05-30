// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  JokeDao? _jokeDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `JokItem` (`category` TEXT, `type` TEXT, `setup` TEXT, `delivery` TEXT, `joke` TEXT, `id` INTEGER, `color` INTEGER, `isBookMark` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  JokeDao get jokeDao {
    return _jokeDaoInstance ??= _$JokeDao(database, changeListener);
  }
}

class _$JokeDao extends JokeDao {
  _$JokeDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _jokItemInsertionAdapter = InsertionAdapter(
            database,
            'JokItem',
            (JokItem item) => <String, Object?>{
                  'category': item.category,
                  'type': item.type,
                  'setup': item.setup,
                  'delivery': item.delivery,
                  'joke': item.joke,
                  'id': item.id,
                  'color': item.color,
                  'isBookMark': item.isBookMark == null
                      ? null
                      : (item.isBookMark! ? 1 : 0)
                }),
        _jokItemUpdateAdapter = UpdateAdapter(
            database,
            'JokItem',
            ['id'],
            (JokItem item) => <String, Object?>{
                  'category': item.category,
                  'type': item.type,
                  'setup': item.setup,
                  'delivery': item.delivery,
                  'joke': item.joke,
                  'id': item.id,
                  'color': item.color,
                  'isBookMark': item.isBookMark == null
                      ? null
                      : (item.isBookMark! ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<JokItem> _jokItemInsertionAdapter;

  final UpdateAdapter<JokItem> _jokItemUpdateAdapter;

  @override
  Future<List<JokItem>> getJoke() async {
    return _queryAdapter.queryList('select * from JokItem',
        mapper: (Map<String, Object?> row) => JokItem(
            category: row['category'] as String?,
            type: row['type'] as String?,
            setup: row['setup'] as String?,
            delivery: row['delivery'] as String?,
            joke: row['joke'] as String?,
            id: row['id'] as int?,
            color: row['color'] as int?,
            isBookMark: row['isBookMark'] == null
                ? null
                : (row['isBookMark'] as int) != 0));
  }

  @override
  Future<List<JokItem>> getBookMarkedJoke() async {
    return _queryAdapter.queryList('select * from JokItem where isBookMark=1',
        mapper: (Map<String, Object?> row) => JokItem(
            category: row['category'] as String?,
            type: row['type'] as String?,
            setup: row['setup'] as String?,
            delivery: row['delivery'] as String?,
            joke: row['joke'] as String?,
            id: row['id'] as int?,
            color: row['color'] as int?,
            isBookMark: row['isBookMark'] == null
                ? null
                : (row['isBookMark'] as int) != 0));
  }

  @override
  Future<void> insertJoke(List<JokItem> jokItem) async {
    await _jokItemInsertionAdapter.insertList(
        jokItem, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePerson(JokItem jokeItem) async {
    await _jokItemUpdateAdapter.update(jokeItem, OnConflictStrategy.replace);
  }
}
