import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogueService {
  // Клас, що надає сервіси для роботи з каталогом продуктів у Firestore

  // Метод для отримання всіх продуктів з Firestore
  Future<List<Map<String, dynamic>>> getProducts() async {
    // Асинхронний метод, що повертає список усіх продуктів з Firestore

    // Створення порожнього списку продуктів
    List<Map<String, dynamic>> products = [];
    try {
      // Отримання всіх документів з колекції "products" у Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      // Перегляд кожного документу
      snapshot.docs.forEach((doc) {
        // Отримання даних про продукт
        Map<String, dynamic> product = doc.data();
        // Додавання ідентифікатора документу як поле "id" до даних про продукт
        product['id'] = doc.id;
        // Додавання даних про продукт до списку продуктів
        products.add(product);
      });
    } catch (e) {
      // Обробка помилок, якщо вони виникли при отриманні продуктів
      print("Error getting products: $e");
    }
    // Повернення списку продуктів
    return products;
  }

  // Метод для отримання продуктів за певною категорією
  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    // Асинхронний метод, що повертає список продуктів з вказаною категорією з Firestore

    // Створення порожнього списку продуктів
    List<Map<String, dynamic>> products = [];
    try {
      // Отримання документів з колекції "products", де поле "type" дорівнює вказаній категорії
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('type', isEqualTo: category)
          .get();
      // Перегляд кожного документу
      snapshot.docs.forEach((doc) {
        // Отримання даних про продукт
        Map<String, dynamic> product = doc.data();
        // Додавання ідентифікатора документу як поле "id" до даних про продукт
        product['id'] = doc.id;
        // Додавання даних про продукт до списку продуктів
        products.add(product);
      });
    } catch (e) {
      // Обробка помилок, якщо вони виникли при отриманні продуктів за категорією
      print("Error getting products by category: $e");
    }
    // Повернення списку продуктів
    return products;
  }
}
