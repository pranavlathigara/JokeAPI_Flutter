
import 'package:floor/floor.dart';
import 'package:flutter_pip/models/JokesResponse.dart';

@dao
abstract class JokeDao{

  @insert
  Future<void> insertJoke(List<JokItem> jokItem);

  @Query('select * from JokItem')
  Future<List<JokItem>> getJoke();

  @Query('select * from JokItem where isBookMark=1')
  Future<List<JokItem>> getBookMarkedJoke();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePerson(JokItem jokeItem);
}