import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../globals.dart' as globals;
import '../screens/header_footer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  late Future<List<Book>> futureBooks;
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _footerKey = GlobalKey();
  final GlobalKey _newsBlockKey = GlobalKey();
  

  @override
  void initState() {
    super.initState();
    futureBooks = ApiService().fetchBooks();
  }

  void searchBooks() async {
    setState(() {
      futureBooks = ApiService().fetchBooks(name: searchQuery);
    });
  }

  Future<List<dynamic>> fetchUserRelations() async {
    if (globals.passId.isEmpty) return [];

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/books_in_relations/list/?pass_id=${globals.passId}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return [];
  }

  void toggleFavorite(int bookId) async {
    if (globals.passId.isEmpty) {
      return;
    }

    List<dynamic> relations = await fetchUserRelations();
    bool isFavorite = relations.any((relation) => relation['book_id'] == bookId && relation['relation'] == 'favorite');

    if (isFavorite) {
      // Удаляем из избранного
      final delResponse = await http.delete(
        Uri.parse('http://127.0.0.1:8000/api/books_in_relations/${globals.passId}/$bookId/'),
        headers: {"Content-Type": "application/json"},
      );
      // Обработка удаления, если нужно
    } else {
      // Добавляем в избранное
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/books_in_relations/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "pass_id": globals.passId,
          "book_id": bookId,
          "relation": "favorite"
        }),
      );
      // Обработка добавления в избранное, если нужно
    }

    setState(() {
      futureBooks = ApiService().fetchBooks(name: searchQuery); // Обновление книг
    });
  }

  void reserveBook(int bookId) async {
    if (globals.passId.isEmpty) {
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/books_in_relations/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "pass_id": globals.passId,
        "book_id": bookId,
        "relation": "reservation"
      }),
    );

    if (response.statusCode == 201) {
      // Обработка успешного бронирования
    }

    setState(() {
      futureBooks = ApiService().fetchBooks(name: searchQuery);
    });
  }


void openBookDetails(Book book) {
  showDialog(
    
    context: context,
    builder: (BuildContext context) {
      var size = MediaQuery.of(context).size;
      double imageWidth;
      double imageHeight;
      if (size.width > 1200) {
        imageWidth = 200.0; // Ширина изображения для экрана более 1200px
        imageHeight = MediaQuery.of(context).size.height*0.8;
      } else if (size.width > 600) {
        imageWidth = 150.0; // Ширина изображения для экрана более 600px
        imageHeight = MediaQuery.of(context).size.height*0.6;
      } else {
        imageWidth = size.width; // Используем всю ширину экрана
        imageHeight = MediaQuery.of(context).size.height*0.3;
      }
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Скругляем углы
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Уменьшение ширины
          height: MediaQuery.of(context).size.height * 0.75, // Высота 60%
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Закрываем диалог
                    },
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), // Скругленные края
                          image: DecorationImage(
                            image: NetworkImage(book.image ?? 'https://via.placeholder.com/150'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        width: imageWidth, // Применяем calculated image width
                        height: imageHeight  ,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Автор: ${book.author}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  'Описание: ${book.description}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (globals.passId.isNotEmpty) ...[
                              ElevatedButton(
                                onPressed: () => reserveBook(book.bookId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0566FF),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                child: const Text('Забронировать', style: TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.5),
      child: Column(
        children: [
          Header(scrollController: _scrollController, footerKey: _footerKey, newsBlockKey: _newsBlockKey),
          TextField(
            onChanged: (value) {
              searchQuery = value;
              searchBooks();
            },
            decoration: const InputDecoration(
              hintText: 'Введите название книги',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нет доступных книг.'));
                }
                var size = MediaQuery.of(context).size;
                
                //final double itemHeight = MediaQuery.of(context).size.height * 0.2;
                final double itemWidth = size.width / 2;
                final double itemHeight = itemWidth*0.6;
                int AxisCount = 1;
                double imageWidth = 200.0;
                if (size.width > 600){
                  AxisCount = 2;
                  imageWidth = 200.0;
                }
                if (size.width > 1200){
                  AxisCount = 3;
                  imageWidth = 180.0;
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AxisCount,
                    childAspectRatio: itemWidth / itemHeight,
                    //childAspectRatio: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final book = snapshot.data![index];
                    return GestureDetector(
                      onTap: () => openBookDetails(book),
                      child: Card(
                        color: const Color(0xFFFFFFFF),
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(book.image ?? 'https://via.placeholder.com/150'),
                                  ),
                                ),
                                //width: MediaQuery.of(context).size.width * 0.15,
                                width: imageWidth,
                                height: MediaQuery.of(context).size.height - 4,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Добавляем отступ сверху для названия книги
                                        const SizedBox(height: 40), // Отступ для свободного места под сердечком
                                        Text(
                                          book.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                        Text(
                                          book.author,
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          book.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                    if (globals.passId.isNotEmpty) ...[
                                      FutureBuilder<List<dynamic>>(
                                        future: fetchUserRelations(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const SizedBox.shrink();
                                          } else if (snapshot.hasError) {
                                            return const SizedBox.shrink();
                                          }

                                          bool isFavorite = snapshot.data!.any((relation) => relation['book_id'] == book.bookId && relation['relation'] == 'favorite');

                                          return Positioned(
                                            top: 8, // Позиция иконки сердца
                                            right: 8,
                                            child: IconButton(
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: Colors.blue, // Синий цвет
                                              ),
                                              onPressed: () => toggleFavorite(book.bookId),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Footer(),
        ],
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  );
}
}
