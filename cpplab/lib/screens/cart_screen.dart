import 'package:flutter/material.dart';
import 'package:cpplab/functions/cart.dart';
import 'order_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> cartItems = _cartService.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Кошик'),
        backgroundColor: Colors.green[200],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildCartItemCard(cartItems[index]);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
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

  Widget _buildCartItemCard(Map<String, dynamic> product) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        title: Text(product['name']),
        subtitle: Text('Ціна: ${product['price']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () {
                // Your code to decrease item quantity
              },
              icon: Icon(Icons.remove),
            ),
            Text(
              '1', // Placeholder for item quantity
              style: TextStyle(fontSize: 18.0),
            ),
            IconButton(
              onPressed: () {
                // Your code to increase item quantity
              },
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                _cartService.removeFromCart(product);
                setState(() {});
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
