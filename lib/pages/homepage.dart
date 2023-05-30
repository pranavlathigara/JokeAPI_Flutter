import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pip/core/store.dart';
import 'package:flutter_pip/models/JokesResponse.dart';
import 'package:flutter_pip/models/app_database.dart';
import 'package:flutter_pip/pages/bookmarked.dart';
import 'package:flutter_pip/transformers/transformers.dart';
import 'package:flutter_pip/widget/card_widget.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class JokesPage extends StatefulWidget {
  const JokesPage({Key? key}) : super(key: key);

  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  final jokesUrl = "https://v2.jokeapi.dev/joke/Programming?amount=10";

  JokesModel? jokesModel;
  Future<AppDatabase> database =
      $FloorAppDatabase.databaseBuilder('joke_db.db').build();

  void navigateSecondPage() {
    Route route = MaterialPageRoute(builder: (context) => BookMarkedPage());
    Navigator.push(context, route).then((value) => onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    database.then((value) => {
          value.jokeDao
              .getBookMarkedJoke()
              .then((value) => {BookMarkMutation(value.isNotEmpty)})
        });
    final storeJoke = (VxState.store as MyStore).jokesModel;
    storeJoke.bookmarked_jokeItems.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    database.then((value) {
      value.jokeDao
          .getBookMarkedJoke()
          .then((value) => {BookMarkMutation(value.isNotEmpty)});
      return {value.jokeDao.getJoke().then((list) => AddMutation(list))};
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    VxState.watch(context,
        on: [AddMutation, BookMarkedJokeMutation, BookMarkMutation]);
    final jokeModel = (VxState.store as MyStore).jokesModel;
    final isBookMarkedAvail = (VxState.store as MyStore).isBookMarkedJokeAvail;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: jokeModel.jokeItems.isNotEmpty
          ? Stack(
              children: [
                TransformerPageView(
                    scrollDirection: Axis.vertical,
                    curve: Curves.easeInBack,
                    transformer: transformers[5],
                    itemCount: jokeModel.jokeItems.length,
                    onPageChanged: (value) {
                      if (value == jokeModel.jokeItems.length - 2) {
                        loadData();
                      }
                      print(value.toString());
                    },
                    itemBuilder: (context, index) {
                      return CardWidget(jokeItem: jokeModel.jokeItems[index]);
                    }),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: isBookMarkedAvail
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            navigateSecondPage();
                          },
                          child: const Text('Bookmarked Joke'),
                        )
                      : SizedBox(),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  loadData() async {
    final response = await http.get(Uri.parse(jokesUrl));
    final jokesResponse = response.body;
    final decodedData = jsonDecode(jokesResponse);
    var productsData = decodedData["jokes"];

    database.then((value) => {
          value.jokeDao
              .insertJoke(List.from(productsData).map<JokItem>((item) {
                return JokItem.fromMap(item);
              }).toList())
              .then((added) => {
                    value.jokeDao.getJoke().then((list) => {AddMutation(list)})
                  })
        });
  }
}
