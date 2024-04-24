import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'package:cpplab/functions/catalogue.dart';
import 'package:cpplab/functions/cart.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late User _currentUser; // Об'єкт поточного користувача
  String _username = ''; // Змінна для збереження імені користувача
  String _selectedCategory = '-'; // Початкова категорія

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!; // Отримання поточного користувача
    _loadUserData(); // Завантаження додаткових даних користувача
  }

  // Метод для завантаження додаткових даних профілю користувача
  void _loadUserData() async {
    // Отримання документу користувача з Firestore
    DocumentSnapshot<Map<String, dynamic>> userData =
    await FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).get();

    // Отримання імені користувача з даних Firestore
    setState(() {
      _username = userData.data()?['username'] ?? ''; // Оновлення імені користувача
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Магазин'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              _showAccountMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: _buildCategoryDropdown(), // Меню з категоріями товарів
          ),
          Expanded(
            child: _buildProductsList(), // Відображення списку продуктів
          ),
        ],
      ),
    );
  }

  // Метод для побудови меню з категоріями товарів
  Widget _buildCategoryDropdown() {
    return Row(
      children: [
        Text('Виберіть категорію товару: '),
        DropdownButton<String>(
          value: _selectedCategory,
          items: <String>['-', 'Фрукти', 'Напої', 'Випічка'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue!;
            });
          },
        ),
      ],
    );
  }


  // Метод для побудови списку продуктів
  Widget _buildProductsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _selectedCategory == '-'
          ? CatalogueService().getProducts()
          : CatalogueService().getProductsByCategory(_selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Map<String, dynamic>> products = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal, // Прокрутка в горизонтальному напрямку
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          );
        }
      },
    );
  }

  // Метод для побудови карточки продукту
  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        _showProductInfoPopup(context, product);
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
        width: 400, // Ширина карточки
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green), // Зелена рамка
          borderRadius: BorderRadius.circular(10.0), // Закруглені кути
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              product['image'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8),
            Text(
              product['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                _showProductInfoPopup(context, product); // Відображення попап-меню при натисканні на кнопку
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: product['available'] ? Colors.green : Colors.grey, // Зелений або сірий колір кнопки
              ),
              child: Text(
                'Ціна: ${product['price']}',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (!product['available']) // Показується, якщо товар недоступний
              Text(
                'Немає в наявності',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

// Метод для відображення попап-меню з інформацією про продукт
  void _showProductInfoPopup(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product['name'].toUpperCase()), // Назва продукту великими літерами
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                product['image'],
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 8),
              Text('Тип: ${product['type']}'), // Тип продукту
              Text('Опис: ${product['description']}'), // Опис продукту
            ],
          ),
          actions: <Widget>[
            if (product['available']) // Додавання кнопки "Додати до кошика" лише якщо продукт доступний
              ElevatedButton(
                onPressed: () {
                  CartService().addToCart(product); // Додавання продукту до кошика
                  Navigator.pop(context); // Закриття попап-меню
                },
                child: Text('Додати до кошика'),
              )
            else
              Text('Товар відсутній'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Закриття попап-меню
              },
              child: Text('Повернутись до покупок'),
            ),
          ],
        );
      },
    );
  }

  // Метод для відображення попап-меню облікового запису
  void _showAccountMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Обліковий запис'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Логін: $_username'),
              Text('Електронна пошта: ${_currentUser.email}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); // Вихід користувача
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()), // Перехід на домашню сторінку
                  );
                },
                child: Text('Log out'),
              ),
            ],
          ),
        );
      },
    );
  }
}