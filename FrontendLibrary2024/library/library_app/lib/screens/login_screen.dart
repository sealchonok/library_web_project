import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals; // Подключение глобальных переменных
import '../screens/header_footer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _footerKey = GlobalKey();
  final GlobalKey _newsBlockKey = GlobalKey();

  Future<void> _authenticate() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/users/authenticate/'), // Замените на ваш URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'pass_id': _passIdController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      globals.passId = _passIdController.text; // Сохранение номера пропуска в глобальной переменной
      Navigator.pop(context);  // Вернуться на предыдущую страницу или перейти на другую
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Ошибка авторизации. Проверьте номер пропуска и пароль.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600; // Условие для ширины экрана
        final double fontSizeHeader = isWideScreen ? 32 : 24; // Размер шрифта заголовка
        final double fontSizeBody = isWideScreen ? 20 : 16; // Размер шрифта тела
        final double buttonPadding = isWideScreen ? 20 : 14; // Отступы для кнопки
        final double padding = isWideScreen ? 80 : 20; // Общие отступы
        final double buttonWidth = isWideScreen ? 200 : double.infinity; // Ширина кнопки
        const double textFieldHeight = 60; // Высота текстового поля

        return Scaffold(
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              children: [
                Header(scrollController: _scrollController, footerKey: _footerKey, newsBlockKey: _newsBlockKey),
                Expanded(
                  child: isWideScreen
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Левый текстовый блок
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0), 
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Откройте новые страницы!',
                                      style: TextStyle(fontSize: fontSizeHeader, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Для получения читательского билета приди в нашу библиотеку и не забудь взять паспорт!',
                                      style: TextStyle(fontSize: fontSizeBody),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Форма авторизации
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0), // Отступы для формы
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: textFieldHeight,
                                      child: TextField(
                                        controller: _passIdController,
                                        decoration: InputDecoration(
                                          labelText: 'Номер пропуска',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      height: textFieldHeight,
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Пароль',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: buttonWidth,
                                      child: ElevatedButton(
                                        onPressed: _authenticate,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0566FF),
                                          padding: EdgeInsets.symmetric(horizontal: buttonPadding, vertical: buttonPadding / 2),
                                        ),
                                        child: Text('Войти', style: TextStyle(fontSize: fontSizeBody, color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Текстовый блок
                            Padding(
                              padding: const EdgeInsets.all(20.0), // Добавить отступы для текста
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Откройте новые страницы!',
                                    style: TextStyle(fontSize: fontSizeHeader, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Для получения читательского билета приди в нашу библиотеку и не забудь взять паспорт!',
                                    style: TextStyle(fontSize: fontSizeBody),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            // Форма авторизации
                            Padding(
                              padding: const EdgeInsets.all(20.0), // Отступы для формы
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: textFieldHeight,
                                    child: TextField(
                                      controller: _passIdController,
                                      decoration: InputDecoration(
                                        labelText: 'Номер пропуска',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: textFieldHeight,
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: 'Пароль',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: buttonWidth,
                                    child: ElevatedButton(
                                      onPressed: _authenticate,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0566FF),
                                        padding: EdgeInsets.symmetric(horizontal: buttonPadding, vertical: buttonPadding / 2),
                                      ),
                                      child: Text('Войти', style: TextStyle(fontSize: fontSizeBody, color: Colors.white)),
                                    ),
                                  ),
                                ],
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
      },
    );
  }
}
