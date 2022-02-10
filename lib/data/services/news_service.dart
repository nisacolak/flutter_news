import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/category_model.dart';
import '../models/article_model.dart';
import '../models/news_model.dart';
import 'api_service.dart';

class NewsServices with ChangeNotifier {
  final _baseUrl = 'newsapi.org';
  final _apiKey = '';

  List<Article> headLines = [];
  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(icon: FontAwesomeIcons.building, name: 'business'),
    Category(icon: FontAwesomeIcons.tv, name: 'entertainment'),
    Category(icon: FontAwesomeIcons.headSideVirus, name: 'health'),
    Category(icon: FontAwesomeIcons.vials, name: 'science'),
    Category(icon: FontAwesomeIcons.volleyballBall, name: 'sports'),
    Category(icon: FontAwesomeIcons.memory, name: 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsServices() {
    getTopHeadLines();

    for (var item in categories) {
      categoryArticles[item.name] = [];
    }
  }

  String get selectedCategory => _selectedCategory;

  set selecteedCategory(String category) {
    _selectedCategory = category;
    getArticlesByCategory(category);
    notifyListeners();
  }

  List<Article>? get getArticleBySelectedCategory =>
      categoryArticles[selectedCategory];

  getTopHeadLines() async {
    final url = Uri.https(_baseUrl, 'v2/top-headlines', {
      'apiKey': _apiKey,
      'country': 'tr',
    });
    final resp = await http.get(url);
    final newsResponse = NewsResponse.fromJson(resp.body);

    headLines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticlesByCategory(String cateory) async {
    if (categoryArticles[cateory]!.isEmpty) return categoryArticles[cateory];

    final url = Uri.https(_baseUrl, 'v2/top-headlines',
        {'apiKey': _apiKey, 'country': 'tr', 'category': cateory});

    final resp = await http.get(url);
    final newsResponse = NewsResponse.fromJson(resp.body);

    categoryArticles[cateory]!.addAll(newsResponse.articles);

    notifyListeners();
  }
}