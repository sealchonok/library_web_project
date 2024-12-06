import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news.dart';
import '../services/api_service.dart';
import '../screens/book_list_screen.dart';
import '../screens/login_screen.dart';
import '../screens/new_arrivals.dart';
import '../globals.dart' as globals; // Подключение глобальных переменных
import '../screens/book_list_screen.dart';
import '../screens/personal_cabinet_screen.dart';



class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
       // Занимает всю ширину родительского контейнера
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Вертикальный и горизонтальный отступ
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Для узкого экрана
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Выровнять по левому краю
              children: [
                Text('Контакты', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('+7(903)740-58-58'),
                Text('openpages@yandex.ru'),
                Text('Москва, ул. Чехова, д.5'),
                SizedBox(height: 16), // Отступ вниз
                Text('Реквизиты', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('ОГРН 1182776675690'),
                Text('ИНН 9701119219'),
                Text('БИК 8238218381229139'),
                SizedBox(height: 16), // Отступ вниз
                Text('Социальные сети', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('/openpages'),
              ],
            );
          } else {
            // Для широкого экрана
            return const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Выровнять по левому краю
              crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание по верхнему краю
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Контакты', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('+7(903)740-58-58'),
                      Text('openpages@yandex.ru'),
                      Text('Москва, ул. Чехова, д.5'),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Отступ между колонками
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Реквизиты', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('ОГРН 1182776675690'),
                      Text('ИНН 9701119219'),
                      Text('БИК 8238218381229139'),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Отступ между колонками
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Социальные сети', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('/openpages'),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}


class Header extends StatelessWidget {
  final ScrollController scrollController;
  final GlobalKey footerKey;
  final GlobalKey newsBlockKey;

  const Header({super.key, required this.scrollController, required this.footerKey, required this.newsBlockKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Уменьшаем отступы
      color: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Для узкого экрана
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('lib/assets/library_logo.jpg', height: 40),
                IconButton(
                  icon: const Icon(Icons.menu), // Иконка меню
                  onPressed: () => _showMenu(context),
                ),
              ],
            );
          } else {
            // Для широкого экрана
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('lib/assets/library_logo.jpg', height: 40),
                    const SizedBox(width: 16),
                    const Text(
                      'Частная библиотека\nОткрытые Страницы',
                      style: TextStyle(
                        color: Color(0xFF101010),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('О нас', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text('Новости', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    const SizedBox(width: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BookListScreen()));
                      },
                      child: const Text('Книжный фонд', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewArrivalsPage()));
                      },
                      child: const Text('Книжные новинки', style: TextStyle(color: Colors.black, fontSize: 16)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (globals.passId.isEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PersonalCabinetScreen()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0566FF),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: Text(
                        globals.passId.isEmpty ? 'Авторизоваться' : 'Личный кабинет',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('О нас'),
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              ListTile(
                title: const Text('Новости'),
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              ListTile(
                title: const Text('Книжный фонд'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BookListScreen()));
                },
              ),
              ListTile(
                title: const Text('Книжные новинки'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewArrivalsPage()));
                },
              ),
              ListTile(
                title: Text(globals.passId.isEmpty ? 'Авторизоваться' : 'Личный кабинет'),
                onTap: () {
                  if (globals.passId.isEmpty) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalCabinetScreen()));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

