import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Імпорт головного екрану додатку
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Імпорт налаштувань Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Забезпечення ініціалізації Flutter перед запуском Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Використання налаштувань Firebase для поточної платформи
  );

  runApp(MyApp()); // Запуск додатку
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магазин продуктів', // Назва додатку
      theme: ThemeData(
        primarySwatch: Colors.blue, // Основний колір теми додатку
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Встановлення головного екрану як початкового екрану додатку
    );
  }
}
