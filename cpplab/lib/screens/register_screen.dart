import 'package:flutter/material.dart';
import 'package:cpplab/functions/register.dart'; // Імпорт методу для реєстрації користувача
import 'shop_screen.dart'; // Імпорт сторінки магазину

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  String _usernameErrorText = '';
  String _emailErrorText = '';
  String _passwordErrorText = '';
  String _confirmPasswordErrorText = '';

  // Метод для перевірки правильності введених полів та реєстрації користувача
  void _validateFields() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // Перевірка правильності заповнення полів
    setState(() {
      _usernameErrorText = RegisterService.validateUsername(username)
          ? ''
          : 'Ім\'я користувача має містити лише літери, цифри, пробіли, апострофи та дефіси';
      _emailErrorText = RegisterService.validateEmail(email)
          ? ''
          : 'Неправильний формат електронної пошти';
      _passwordErrorText = RegisterService.validatePassword(password)
          ? ''
          : 'Пароль має містити лише літери та цифри';
      _confirmPasswordErrorText =
      password == confirmPassword ? '' : 'Паролі не співпадають';
    });

    // Перевіряємо, чи всі поля введені правильно перед реєстрацією
    if (_usernameErrorText.isEmpty &&
        _emailErrorText.isEmpty &&
        _passwordErrorText.isEmpty &&
        _confirmPasswordErrorText.isEmpty) {
      // Викликаємо метод реєстрації користувача із register.dart
      bool success = await RegisterService.registerUser(email, password, username);
      if (success) {
        // Якщо реєстрація пройшла успішно, виконуємо дії, наприклад, перехід на іншу сторінку
        Navigator.push(context, MaterialPageRoute(builder: (context) => ShopScreen()),);
      } else {
        // Якщо реєстрація не вдалася, відображаємо повідомлення про помилку
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Помилка реєстрації. Будь ласка, спробуйте ще раз.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Реєстрація'),
        backgroundColor: Colors.green[200], // Сіро-зелений колір для AppBar
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[200], // Сірий фон для body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Ім\'я користувача',
                fillColor: Colors.white,
                filled: true,
                errorText: _usernameErrorText, // Відображення тексту помилки для ім'я користувача
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Електронна пошта',
                fillColor: Colors.white,
                filled: true,
                errorText: _emailErrorText, // Відображення тексту помилки для електронної пошти
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль (мінімум 6 сиволів)',
                fillColor: Colors.white,
                filled: true,
                errorText: _passwordErrorText, // Відображення тексту помилки для пароля
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Підтвердження паролю',
                fillColor: Colors.white,
                filled: true,
                errorText: _confirmPasswordErrorText, // Відображення тексту помилки для підтвердження паролю
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _validateFields(); // Виклик методу для перевірки полів та реєстрації користувача
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[200], // Світло-зелений колір для кнопки
              ),
              child: Text(
                'Зареєструватися',
                style: TextStyle(color: Colors.white), // Білий колір для тексту кнопки
              ),
            ),
          ],
        ),
      ),
    );
  }
}
