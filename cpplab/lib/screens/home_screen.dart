import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
              decoration: InputDecoration(
                labelText: 'Логін',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Пароль',
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Дії, які виконуються при натисканні кнопки
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
                // Дії, які виконуються при натисканні посилання на реєстрацію
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
