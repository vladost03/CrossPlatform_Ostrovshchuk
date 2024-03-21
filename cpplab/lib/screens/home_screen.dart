import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ласкаво просимо до нашого магазину продуктів!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Дії, які виконуються при натисканні кнопки
              },
              child: Text('Переглянути продукти'),
            ),
          ],
        ),
      ),
    );
  }
}