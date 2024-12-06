// Модель данных для новостей
class News {
  final int newsId;
  final String title;
  final String message;
  final String jpg;

  News({required this.newsId, required this.title, required this.message, required this.jpg});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['news_id'],
      title: json['title'],
      message: json['message'],
      jpg: json['jpg'],
    );
  }
}
