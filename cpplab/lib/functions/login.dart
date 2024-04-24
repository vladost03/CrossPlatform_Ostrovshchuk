import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkCredentials(String email, String password) async {
    try {
      // Спроба виконати вход за допомогою електронної пошти та пароля
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Перевірка, чи користувач успішно авторизувався
      return userCredential.user != null;
    } catch (e) {
      print('Error checking credentials: $e');
      return false; // Помилка перевірки облікових даних
    }
  }
}
