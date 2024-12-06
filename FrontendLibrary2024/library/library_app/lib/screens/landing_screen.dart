import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news.dart';
import '../services/api_service.dart';
import '../screens/book_list_screen.dart';
import '../screens/login_screen.dart';
import '../globals.dart' as globals; // Подключение глобальных переменных
import '../screens/personal_cabinet_screen.dart';
import '../screens/header_footer.dart';

class Landing extends StatelessWidget {
  Landing({super.key});
  final ScrollController _scrollController = ScrollController();
  final GlobalKey footerKey = GlobalKey();
  final GlobalKey newsBlockKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        children: [
          Header(scrollController: _scrollController, footerKey: footerKey, newsBlockKey: newsBlockKey),
          const MainContent(key: Key('main_content')),
          Footer(key: footerKey),
        ],
      ),
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GeneralBlock(),
        NewsBlock(),
        SizedBox(height: 20),
      ],
    );
  }
}

class GeneralBlock extends StatelessWidget {
  
  const GeneralBlock({super.key});
  

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final ScrollController scrollController = ScrollController();

    return Container(
      
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 20),
                      child: Text(
                        'Ваш личный уголок знаний, \nвдохновения и приключений!',
                        style: TextStyle(
                          fontSize: 36 * textScaleFactor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Заполните форму по ссылке для более быстрого получения билета в нашей библиотеке.',
                      style: TextStyle(
                        fontSize: 16 * textScaleFactor,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        launchURL('https://edu.gubkin.ru/course/view.php?id=72935');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0566FF),
                        padding: EdgeInsets.symmetric(horizontal: 20 * screenWidth / 400, vertical: 16),
                      ),
                      child: Text(
                        'Получить читательский билет',
                        style: TextStyle(fontSize: 16 * textScaleFactor, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('lib/assets/library_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Горизонтальный список с карточками
          const SizedBox(
            height: 180,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ColorCard(title: 'Уникальная коллекция', description: 'Редкие и современные книги, классика и новинки.'),
                  SizedBox(width: 20),
                  ColorCard(title: 'Уютная атмосфера', description: 'Комфортное и спокойное чтение.'),
                  SizedBox(width: 20),
                  ColorCard(title: 'Лекторий Открытых страниц', description: 'Лекции и мастер-классы.'),
                  SizedBox(width: 20),
                  ColorCard(title: 'Кофейные Страницы', description: 'Идеальная атмосфера для чтения.'),
                  SizedBox(width: 20),
                  ColorCard(title: 'Современные технологии', description: 'Инновации и новшества в чтении.'),
                  SizedBox(width: 20),
                  ColorCard(title: 'Классическая литература', description: 'Шедевры мировой литературы.'),
                ],
                
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}

class ColorCard extends StatelessWidget {
  final String title;
  final String description;

  const ColorCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.textScaleFactorOf(context); // Получаем коэффициент масштабирования текста

    return Container(
      width: 240, // Фиксированная ширина карточки
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20 * textScaleFactor), // Адаптивный размер
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.white, fontSize: 16 * textScaleFactor), // Адаптивный размер
          ),
        ],
      ),
    );
  }
}

class NewsBlock extends StatelessWidget {
  const NewsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService(); // Создаем экземпляр ApiService

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(color: Color(0xFFFAFAFA)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Новости',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: FutureBuilder<List<News>>(
              future: apiService.fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Ошибка загрузки новостей'));
                }
                final news = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: news.length,
                  itemBuilder: (context, index) {
                    final newsItem = news[index];
                    return NewsCard(news: newsItem);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Скругляем углы
              ),
              backgroundColor: const Color(0xFFFAFAFA),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // Уменьшаем ширину
                height: MediaQuery.of(context).size.height * 0.85, // Высота 85%
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
                    // Здесь теперь изображение будет сверху
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4, 
                      width: MediaQuery.of(context).size.width * 0.7,// Высота изображения
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // Скругленные края
                        image: DecorationImage(
                          image: NetworkImage(news.jpg),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                news.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                news.message,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(news.jpg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            news.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
void launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}
