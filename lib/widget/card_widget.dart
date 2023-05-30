import 'dart:math';
import 'package:flutter_pip/core/store.dart';
import 'package:flutter_pip/models/JokesResponse.dart';
import 'package:flutter_pip/models/app_database.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CardWidget extends StatefulWidget {
  final JokItem jokeItem;

  const CardWidget({
    required this.jokeItem,
    Key? key,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  Future<AppDatabase> database =
      $FloorAppDatabase.databaseBuilder('joke_db.db').build();

  @override
  Widget build(BuildContext context) {
    String joke = "";
    if (widget.jokeItem.type == "twopart") {
      joke = "${widget.jokeItem.setup}\n${widget.jokeItem.delivery}";
    } else {
      joke = widget.jokeItem.joke!;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(widget.jokeItem.color!)),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                if (widget.jokeItem.isBookMark!) {
                  widget.jokeItem.isBookMark = false;
                } else {
                  widget.jokeItem.isBookMark = true;
                }
                updateJokeItem();
              },
              child: Icon(
                widget.jokeItem.isBookMark!
                    ? Icons.bookmark_add_rounded
                    : Icons.bookmark_outline_rounded,
                color: Vx.black,
                size: 40,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              joke,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 28),
            ),
          ),
          const SizedBox(height: 5)
        ],
      ),
    );
  }

  updateJokeItem() {
    database.then((value) => {value.jokeDao.updatePerson(widget.jokeItem)});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          widget.jokeItem.isBookMark! ? "Bookmark added" : "Bookmark removed"),
    ));
    setState(() {});

    database.then((value) => {
          value.jokeDao
              .getBookMarkedJoke()
              .then((value) => {BookMarkMutation(value.isNotEmpty)})
        });
  }
}
