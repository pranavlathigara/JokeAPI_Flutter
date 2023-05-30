import 'package:flutter_pip/models/JokesResponse.dart';
import 'package:flutter_pip/models/app_database.dart';
import 'package:velocity_x/velocity_x.dart';

class MyStore extends VxStore {
  late JokesModel jokesModel;

  late bool isBookMarkedJokeAvail;

  MyStore() {
    jokesModel = JokesModel();
    isBookMarkedJokeAvail = false;
  }
}

class BookMarkMutation extends VxMutation<MyStore> {
  bool isBookMarkAvail;

  BookMarkMutation(this.isBookMarkAvail);

  @override
  perform() {
    store?.isBookMarkedJokeAvail = isBookMarkAvail;
  }
}
