import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import '../globals.dart' as globals;
import '../screens/header_footer.dart';

class PersonalCabinetScreen extends StatefulWidget {
  const PersonalCabinetScreen({super.key});

  @override
  _PersonalCabinetScreenState createState() => _PersonalCabinetScreenState();
}

class _PersonalCabinetScreenState extends State<PersonalCabinetScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _footerKey = GlobalKey();
  final GlobalKey _newsBlockKey = GlobalKey();
  List<Map<String, dynamic>> myBooks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/api/books_in_relations/list/info/${globals.passId}/'));

    if (response.statusCode == 200) {
      final decodedData = utf8.decode(response.bodyBytes);
      final List<dynamic> data = json.decode(decodedData);
      
      setState(() {
        myBooks = data.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Обработка ошибок запроса
    }
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Скопировано: $text')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем ширину и высоту экрана
    final size = MediaQuery.of(context).size;
    // Определяем адаптивные размеры
    final double titleFontSize = size.width > 600 ? 32 : 24;
    final double columnFontSize = size.width > 600 ? 24 : 18;
    final double rowFontSize = size.width > 600 ? 20 : 16;
    final double buttonFontSize = size.width > 600 ? 20 : 16;
    final double padding = size.width > 600 ? 16 : 8;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(padding),
        color: Colors.white,
        child: Column(
          children: [
            Header(scrollController: _scrollController, footerKey: _footerKey, newsBlockKey: _newsBlockKey),
            Padding(
              padding: EdgeInsets.only(bottom: padding),
              child: Text(
                'Мои книги',
                style: TextStyle(color: Colors.black, fontSize: titleFontSize),
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columnSpacing: padding * 2, // Расстояние между столбцами
                        columns: [
                          DataColumn(label: Text('Название', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: columnFontSize))),
                          DataColumn(label: Text('Автор', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: columnFontSize))),
                          DataColumn(label: Text('Статус', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: columnFontSize))),
                        ],
                        rows: myBooks.map((book) {
                          return DataRow(cells: [
                            DataCell(
                              Text(book['name'] ?? '', style: TextStyle(color: Colors.black, fontSize: rowFontSize)),
                              onTap: () => copyToClipboard(book['name'] ?? ''),
                            ),
                            DataCell(
                              Text(book['author'] ?? '', style: TextStyle(color: Colors.black, fontSize: rowFontSize)),
                              onTap: () => copyToClipboard(book['author'] ?? ''),
                            ),
                            DataCell(
                              Text(book['relation'] ?? '', style: TextStyle(color: Colors.black, fontSize: rowFontSize)),
                              onTap: () => copyToClipboard(book['relation'] ?? ''),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            // Footer
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Здесь вы можете выйти из личного кабинета. Хотите выйти?',
                    style: TextStyle(fontSize: buttonFontSize), // Текст вопроса о выходе
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      globals.passId = ""; // Обнуление глобальной переменной
                      Navigator.pop(context); // Вернуться на предыдущую страницу
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0566FF),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                    child: Text(
                      'Да, выйти',
                      style: TextStyle(color: Colors.white, fontSize: buttonFontSize), // Увеличенный размер шрифта
                    ),
                  ),
                ],
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
