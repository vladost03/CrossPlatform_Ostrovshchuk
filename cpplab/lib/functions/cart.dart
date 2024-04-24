import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  // Створення глобального екземпляру класу CartService (singleton)
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  // Список продуктів у кошику
  List<Map<String, dynamic>> _cartItems = [];

  // Метод для отримання списку продуктів у кошику
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Метод для додавання продукту до кошика
  Future<void> addToCart(Map<String, dynamic> product) async {
    // Перевірка, чи продукт ще не міститься у кошику
    bool alreadyInCart = await isProductInCart(product);

    if (!alreadyInCart) {
      _cartItems.add(product);
    }
  }

  // Метод для перевірки, чи продукт вже є у кошику
  Future<bool> isProductInCart(Map<String, dynamic> product) async {
    // Запит до Firestore для отримання інформації про продукт
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('id', isEqualTo: product['id']) // Пошук продукту за ID
        .limit(1) // Лімітуємо кількість результатів до 1
        .get();

    // Перевірка, чи знайдено продукт
    return snapshot.docs.isNotEmpty;
  }

  // Метод для видалення продукту з кошика
  void removeFromCart(Map<String, dynamic> product) {
    _cartItems.removeWhere((item) => item['id'] == product['id']);
  }

  // Метод для видалення всіх продуктів з кошика
  void clearCart() {
    _cartItems.clear();
  }
  // Метод для обчислення суми продуктів в кошику
  double calculateTotal() {
    double total = 0.0;
    for (var product in _cartItems) {
      total += product['price'];
    }
    return total;
  }
}
