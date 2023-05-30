import 'package:flutter/material.dart';
import 'package:flutter_pip/core/store.dart';
import 'package:flutter_pip/models/JokesResponse.dart';
import 'package:flutter_pip/models/app_database.dart';
import 'package:flutter_pip/transformers/transformers.dart';
import 'package:flutter_pip/widget/card_widget.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:velocity_x/velocity_x.dart';

class BookMarkedPage extends StatefulWidget {
  const BookMarkedPage({Key? key}) : super(key: key);

  @override
  State<BookMarkedPage> createState() => _BookMarkedPageState();
}

class _BookMarkedPageState extends State<BookMarkedPage> {
  Future<AppDatabase> database =
      $FloorAppDatabase.databaseBuilder('joke_db.db').build();

  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [BookMarkedJokeMutation]);
    final jokeModel = (VxState.store as MyStore).jokesModel;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: jokeModel.jokeItems.isNotEmpty
          ? Stack(
              children: [
                TransformerPageView(
                    scrollDirection: Axis.vertical,
                    curve: Curves.easeInBack,
                    transformer: transformers[5],
                    itemCount: jokeModel.bookmarked_jokeItems.length,
                    onPageChanged: (value) {},
                    itemBuilder: (context, index) {
                      return CardWidget(jokeItem: jokeModel.bookmarked_jokeItems[index]);
                    }),
                 Padding(
                  padding: const EdgeInsets.fromLTRB(10,40,10,10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Vx.black,
                      size: 40,
                    ),
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();
    database.then((value) {
      return {
        value.jokeDao.getBookMarkedJoke().then((list) => BookMarkedJokeMutation(list))
      };
    });
  }
}
