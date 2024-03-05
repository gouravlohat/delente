class Article {
  final String title;
  final String image;
  final String smallDesc;
  final int totalArticle;
  final bool hasMoreArticle;
  final String? newsFor;

  Article({
    required this.title,
    required this.image,
    required this.smallDesc,
    required this.totalArticle,
    required this.hasMoreArticle,
    this.newsFor,
  });
}
