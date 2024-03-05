import 'dart:convert';

import 'package:delenet_assignment/models/articleModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ArticleProvider with ChangeNotifier {
  List<Article> _articles = [];
  int _totalArticles = 0;
  bool _hasMoreArticles = false;
  bool _isLoading = false;

  List<Article> get articles => _articles;
  int get totalArticles => _totalArticles;
  bool get hasMoreArticles => _hasMoreArticles;
  bool get isLoading => _isLoading;

  List<Article> get articlesWithNewsFor =>
      _articles.where((article) => article.newsFor != null).toList();

  Future<void> fetchArticles() async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse(
          'https://prod.cmv360.com/api/v4/get-articles?moreArticles=1'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        _totalArticles = responseData['articleData']['totalArticle'];
        _hasMoreArticles =
            responseData['articleData']['hasMoreArticle'] as bool;

        final List<dynamic> data = responseData['articleData']['data'];

        _articles.addAll(List<Article>.from(data.map((articleData) {
          return Article(
            title: articleData['title'] as String? ?? "",
            image: articleData['image'] as String? ?? "",
            smallDesc: articleData['smallDesc'] as String? ?? "",
            totalArticle: _totalArticles,
            hasMoreArticle: _hasMoreArticles,
            newsFor: articleData['newsFor'] as String?,
          );
        })));
      } else {
        // Handle errors
        print('Failed to load articles');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      Future.microtask(() {
        _isLoading = false;
        notifyListeners();
      });
    }
  }
}
