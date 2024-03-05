import 'package:delenet_assignment/Provider/articleProvider.dart';
import 'package:delenet_assignment/models/articleModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryArticleScreen extends StatelessWidget {
  final String category;

  CategoryArticleScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    List<Article> filteredArticles = Provider.of<ArticleProvider>(context)
        .articlesWithNewsFor
        .where((article) => article.newsFor == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$category Articles'),
      ),
      body: ListView.builder(
        itemCount: filteredArticles.length,
        itemBuilder: (context, index) {
          final article = filteredArticles[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Image.network(article.image),
                  Text(
                    article.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(article.smallDesc),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
