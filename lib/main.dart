import 'package:delenet_assignment/Provider/articleProvider.dart';
import 'package:delenet_assignment/screens/articleScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ArticleProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Article App',
      home: ArticleScreen(),
    );
  }
}
