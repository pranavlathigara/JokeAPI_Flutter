import 'dart:convert';
import 'dart:math';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pip/core/store.dart';
import 'package:velocity_x/velocity_x.dart';

class JokesModel {
  final List<JokItem> jokeItems = [];
  final List<JokItem> bookmarked_jokeItems = [];
}

@entity
class JokItem {
  final String? category;
  final String? type;
  final String? setup;
  final String? delivery;
  final String? joke;
  @primaryKey
  final int? id;
  final int? color;
  bool? isBookMark;

  JokItem(
      {this.category,
      this.type,
      this.setup,
      this.delivery,
      this.joke,
      this.id,
      this.color,
      this.isBookMark});

  factory JokItem.fromMap(Map<String, dynamic> map) {
    return JokItem(
        category: map['category'],
        type: map['type'],
        setup: map['setup'],
        delivery: map['delivery'],
        joke: map['joke'],
        id: map['id'],
        isBookMark: false,
        color:
            Colors.primaries[Random().nextInt(Colors.primaries.length)].value);
  }
}

class AddMutation extends VxMutation<MyStore> {
  var list;

  AddMutation(this.list);

  @override
  perform() {
    store?.jokesModel.jokeItems.addAll(list);
  }
}

class BookMarkedJokeMutation extends VxMutation<MyStore> {
  var list;

  BookMarkedJokeMutation(this.list);

  @override
  perform() {
    store?.jokesModel.bookmarked_jokeItems.clear();
    store?.jokesModel.bookmarked_jokeItems.addAll(list);
  }
}
