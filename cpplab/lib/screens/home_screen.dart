import 'package:flutter/material.dart';
import 'shop_screen.dart'; // Імпорт сторінки магазину
import 'register_screen.dart'; // Імпорт сторінки реєстрації
import 'package:cpplab/functions/login.dart'; // Імпорт методу для авторизації

class HomeScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизація', style: TextStyle(color: Colors.grey)), // Назва AppBar
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
              obscureText: true, // Пароль прихований
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                // Обробник події натискання кнопки "Вхід"
                bool isAuthenticated = await LoginService().checkCredentials(
                  _emailController.text,
                  _passwordController.text,
                ); // Перевірка облікових даних

                if (isAuthenticated) {
                  // Якщо користувач вдало авторизований, переходимо на сторінку магазину
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ShopScreen()),
                  );
                } else {
                  // Якщо авторизація не вдалася, виводимо повідомлення про помилку
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
                // Обробник події натискання тексту "Ще не зареєстровані? Зареєструватися"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()), // Перехід на сторінку реєстрації
                );
              },
              child: Text(
                'Ще не зареєстровані? Зареєструватися',
                style: TextStyle(color: Colors.blue), // Синій колір для тексту
              ),
            ),
          ],
        ),
      ),
    );
  }
}
