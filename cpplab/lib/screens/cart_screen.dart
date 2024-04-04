import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Кошик'),
    backgroundColor: Colors.green[200], // Сіро-зелений колір для AppBar
    ),
    body: Container(
    padding: EdgeInsets.all(20.0),
    color: Colors.grey[200], // Сірий фон для body
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    Text(
    'Тут буде вміст кошика', // Вміст кошика
    style: TextStyle(fontSize: 20.0),
    ),
    SizedBox(height: 20.0),
    Expanded(
    child: SizedBox(), // Пустий віджет, щоб розділити кнопки від іншого вмісту
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Розташування кнопок по всій ширині екрану
    children: <Widget>[
    ElevatedButton(
    onPressed: () {
    // Дія, яка відбувається при натисканні кнопки "Повернутись до покупок"
    Navigator.pop(context); // Повертаємося на сторінку магазину
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green[200], // Світло-зелений колір для кнопки
    ),
    child: Text(
    'Повернутись до покупок',
    style: TextStyle(color: Colors.grey), // Сірий колір для тексту кнопки
    ),
    ),
    ElevatedButton(
    onPressed: () {
    // Дія, яка відбувається при натисканні кнопки "Очистити кошик"
    // Ваш код для очищення кошика
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red, // Червоний колір для кнопки
    ),
    child: Text(
    'Очистити кошик',
    style: TextStyle(color: Colors.white), // Білий колір для тексту кнопки
    ),
    ),
    ElevatedButton(
    onPressed: () {
    // Дія, яка відбувається при натисканні кнопки "Перейти до сплати"
    // Ваш код для переходу до сплати
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Синій колір для кнопки
    ),
    child: Text(
    'Перейти до сплати',
    style: TextStyle(color: Colors.white), // Білий колір для тексту кнопки
    ),
    ),
    ],
    ),
    ],
    ),
    ),
    );
  }
}