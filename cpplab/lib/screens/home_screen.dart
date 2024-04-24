import 'package:flutter/material.dart';
import 'shop_screen.dart';
import 'register_screen.dart';
import 'package:cpplab/functions/login.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизація', style: TextStyle(color: Colors.grey)),
        backgroundColor: Colors.green[200], // Сіро-зелений колір для AppBar
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[200], // Сірий фон для body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Електронна пошта',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Виклик методу для перевірки облікових даних
                bool isAuthenticated = await LoginService().checkCredentials(
                  _emailController.text,
                  _passwordController.text,
                );

                if (isAuthenticated) {
                  // Перехід на сторінку магазину, якщо користувач вдало авторизований
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ShopScreen()),
                  );
                } else {
                  // Виведення повідомлення про помилку, якщо авторизація не вдалася
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Неправильна електронна пошта або пароль'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[200], // Світло-зелений колір для кнопки
              ),
              child: Text(
                'Вхід',
                style: TextStyle(color: Colors.grey), // Сірий колір для тексту кнопки
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                // Перехід на сторінку реєстрації при натисканні посилання
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Ще не зареєстровані? Зареєструватися',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
