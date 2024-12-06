// lib/models/book.dart
class Book {
  final int bookId;
  final String name;
  final String author;
  final String description;
  final String? image;
  final int count; 

  Book({required this.bookId, required this.name, required this.author,required this.description, this.image,required this.count});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      bookId: json['book_id'], // Изменено для использования book_id
      name: json['name'],
      author: json['author'],
      description: json['description'],
      count: json['count'],
      image: json['image'], // Здесь может быть null
    );
  }
}
