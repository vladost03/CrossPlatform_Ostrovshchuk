import 'package:flutter/material.dart';
import 'cart_screen.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  String _username = "user123"; // Логін користувача

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Дія, яка відбувається при натисканні кнопки "Кошик"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Відкриття попап-меню облікового запису
              _showAccountMenu(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Тут ви побачите продукти магазину'),
      ),
    );
  }

  // Функція для відображення попап-меню облікового запису
  void _showAccountMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Обліковий запис'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Логін: $_username'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Дія, яка відбувається при натисканні кнопки "Log out"
                },
                child: Text('Log out'),
              ),
            ],
          ),
        );
      },
    );
  }
}
