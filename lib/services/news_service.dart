import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsly/models/article_model.dart';

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  // TODO: Replace with your actual NewsAPI key
  static const String _apiKey = 'YOUR_NEWSAPI_KEY';

  // Categories for the app
  static const List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  // Get top headlines
  Future<List<Article>> getTopHeadlines({String category = 'general'}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(data);
      return newsResponse.articles;
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Search news by keyword
  Future<List<Article>> searchNews(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final newsResponse = NewsResponse.fromJson(data);
      return newsResponse.articles;
    } else {
      throw Exception('Failed to search news');
    }
  }
}
