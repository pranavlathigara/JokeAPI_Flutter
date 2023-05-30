import 'package:flutter/material.dart';
import 'package:flutter_pip/core/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'pages/homepage.dart';

void main() {
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JokesPage(),
    );
  }
}
