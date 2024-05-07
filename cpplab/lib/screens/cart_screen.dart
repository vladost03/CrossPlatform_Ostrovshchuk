import 'package:flutter/material.dart';
import 'package:cpplab/functions/cart.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService(); // Створення об'єкту для роботи з кошиком

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cartItems = _cartService.cartItems; // Отримання елементів кошика

    return Scaffold(
      appBar: AppBar(
        title: Text('Кошик', style: TextStyle(color: Colors.grey)),
        backgroundColor: Colors.green[200], // Встановлення колірної схеми для заголовку
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[200], // Встановлення колірної схеми для тіла екрану
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCartItemCard(cartItems[index]); // Побудова карточки товару у кошику
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Кнопка для повернення до списку товарів
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                  ),
                  child: Text(
                    'Повернутись до покупок',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Кнопка для очищення кошика
                ElevatedButton(
                  onPressed: () {
                    _cartService.clearCart();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Очистити кошик',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Кнопка для переходу до екрану оформлення замовлення
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Перейти до сплати',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Метод для побудови карточки товару у кошику
  Widget _buildCartItemCard(Map<String, dynamic> product) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(product['name']), // Назва товару
        subtitle: Text('Ціна: ${product['price']}'), // Ціна товару
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () {
                // Ваш код для зменшення кількості товару
              },
              icon: Icon(Icons.remove),
            ),
            Text(
              '1', // Заглушка для кількості товару
              style: TextStyle(fontSize: 18.0),
            ),
            IconButton(
              onPressed: () {
                // Ваш код для збільшення кількості товару
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                _cartService.removeFromCart(product); // Видалення товару з кошика
                setState(() {});
              },
              icon: Icon(Icons.delete), // Іконка для видалення товару з кошика
            ),
          ],
        ),
      ),
    );
  }
}
