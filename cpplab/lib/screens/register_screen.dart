import 'package:flutter/material.dart';
import 'package:cpplab/functions/register.dart';
import 'shop_screen.dart';

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
                errorText: _usernameErrorText,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Електронна пошта',
                fillColor: Colors.white,
                filled: true,
                errorText: _emailErrorText,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                fillColor: Colors.white,
                filled: true,
                errorText: _passwordErrorText,
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
                errorText: _confirmPasswordErrorText,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _validateFields();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[200], // Світло-зелений колір для кнопки
              ),
              child: Text(
                'Зареєструватися',
                style: TextStyle(color: Colors.white), // Сірий колір для тексту кнопки
              ),
            ),
          ],
        ),
      ),
    );
  }
}
