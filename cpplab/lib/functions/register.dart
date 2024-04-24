import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class RegisterService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> registerUser(String email, String password, String username) async {
    try {
      // Створення нового користувача у Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Отримання ідентифікатора створеного користувача
      String userId = userCredential.user!.uid;

      // Збереження додаткових даних користувача у Firestore
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'password': password,
      });

      return true; // Реєстрація пройшла успішно
    } catch (e) {
      print('Error registering user: $e');
      return false; // Помилка реєстрації користувача
    }
  }
  // Метод для перевірки правильності введеного імені користувача
  static bool validateUsername(String username) {
    // Паттерн для перевірки імені користувача
    RegExp usernameRegex = RegExp(r'^[a-zA-Zа-яА-Я0-9]+$');
    return usernameRegex.hasMatch(username);
  }

  // Метод для перевірки правильності введеної електронної пошти
  static bool validateEmail(String email) {
    // Паттерн для перевірки електронної пошти
    RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Метод для перевірки правильності введеного пароля
  static bool validatePassword(String password) {
    // Паттерн для перевірки пароля
    RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return passwordRegex.hasMatch(password);
  }

  // Метод для перевірки співпадіння пароля та підтвердження пароля
  static bool confirmPassword(String password, String confirmPassword) {
    return password == confirmPassword;
  }
}
