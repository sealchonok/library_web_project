import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';
import '../models/news.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api';

  
  Future<List<Book>> fetchBooks({String? author, String? name}) async {
    var uri = Uri.parse('$baseUrl/books/');
    if (author != null || name != null) {
      final queryParameters = {
        if (author != null) 'author': author,
        if (name != null) 'name': name,
      };
      uri = uri.replace(queryParameters: queryParameters);
    }

    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Ошибка загрузки книг');
    }
  }
  Future<List<News>> fetchNews() async {
  final response = await http.get(Uri.parse('$baseUrl/news/'));

  if (response.statusCode == 200) {
    try {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes)); // Убедитесь, что используется нужная кодировка
      return data.map((newsItem) => News.fromJson(newsItem)).toList();
    } catch (e) {
      throw Exception('Ошибка при разборе ответа: $e');
    }
  } else {
    throw Exception('Ошибка загрузки новостей: ${response.statusCode}');
  }
}
  Future<void> toggleFavorite(int bookId) async {
    await http.post(
      Uri.parse('$baseUrl/favorites/'),
      body: json.encode({'book_id': bookId}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> reserveBook(int bookId) async {
    await http.post(
      Uri.parse('$baseUrl/reservations/'),
      body: json.encode({'book_id': bookId}),
      headers: {'Content-Type': 'application/json'},
    );
  }
  

  Future<List<Book>> fetchNewBooks({String? name}) async {
    var uri = Uri.parse('$baseUrl/new_books');
   
      final queryParameters = {
        if (name != null) 'name': name,
      };
      uri = uri.replace(queryParameters: queryParameters);
    

    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((book) => Book.fromJson(book)).toList();
    } else {
      throw Exception('Ошибка загрузки книг');
    }
  }



}
