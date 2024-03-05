import 'package:delenet_assignment/Provider/articleProvider.dart';
import 'package:delenet_assignment/models/articleModel.dart';
import 'package:delenet_assignment/screens/categoryArticle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  final ScrollController _scrollController = ScrollController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    // Fetch all articles when the screen is initialized
    Provider.of<ArticleProvider>(context, listen: false).fetchArticles();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);

    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        articleProvider.hasMoreArticles) {
      // Fetch more articles only if hasMoreArticle is true
      articleProvider.fetchArticles();
    }
  }

  List<String> getCategoryList(List<Article> articles) {
    // Extract unique categories from articles
    Set<String> categories =
        articles.map((article) => article.newsFor ?? "").toSet();
    return categories.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Screen'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'All Articles'),
                Tab(text: 'Categories'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildArticleList(
                      context, Provider.of<ArticleProvider>(context).articles),
                  _buildCategoryList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context, List<Article> articles) {
    return Consumer<ArticleProvider>(
      builder: (context, articleProvider, _) {
        return Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
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
            if (articleProvider
                .isLoading) // Show loading indicator if data is loading
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList() {
    return Consumer<ArticleProvider>(
      builder: (context, articleProvider, _) {
        List<String> categories =
            getCategoryList(articleProvider.articlesWithNewsFor);

        return ListView.builder(
          controller: _scrollController,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryArticleScreen(category: category),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
