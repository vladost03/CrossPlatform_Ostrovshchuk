import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cpplab/functions/cart.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _paymentMethod = ''; // Змінна для збереження обраного способу оплати
  String _deliveryMethod = ''; // Змінна для збереження обраного способу доставки
  //Змінні для контролю введених реквізитів картки
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _deliveryAddressController = TextEditingController();
  List<String> _pickupAddresses = []; // Список для зберігання адрес самовивозу

  @override
  void initState() {
    super.initState();
    _fetchRandomAddresses(); // Виклик методу для отримання випадкових адрес самовивозу
  }

  // Метод для отримання випадкових адрес самовивозу
  Future<void> _fetchRandomAddresses() async {
    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/?results=6')); // Запит на отримання даних
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Декодування отриманих даних у форматі JSON
        final List<dynamic> results = data['results'];
        setState(() {
          _pickupAddresses = results.map((result) {
            final city = result['location']['city'];
            final street = result['location']['street']['name'];
            final streetNumber = result['location']['street']['number'];
            return '$city, $street, $streetNumber'; // Створення адреси у форматі: місто, вулиця, номер будинку
          }).toList();
        });
      } else {
        throw Exception('Failed to load addresses'); // Якщо статус відповіді не 200, викинути виняток
      }
    } catch (error) {
      print('Error: $error'); // Вивести помилку у випадку, якщо її виникнення
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = CartService().calculateTotal(); // Обчислення загальної суми товарів у кошику

    return Scaffold(
      appBar: AppBar(
        title: Text('Оформлення замовлення'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Відображення загальної суми до сплати
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сума до сплати:',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} грн', // Округлена сума до двох знаків після коми
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            // Вибір способу оплати
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Виберіть спосіб оплати:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
            // Пункти вибору способу оплати
            ListTile(
              title: Text('Картка'),
              leading: Radio(
                value: 'card',
                groupValue: _paymentMethod, // Поточне значення вибору способу оплати
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value as String;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Готівка'),
              leading: Radio(
                value: 'cash',
                groupValue: _paymentMethod, // Поточне значення вибору способу оплати
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value as String;
                  });
                },
              ),
            ),
            // Введення реквізитів картки, якщо обрано спосіб оплати "Картка"
            if (_paymentMethod == 'card') ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _cardNumberController,
                      decoration: InputDecoration(labelText: 'Номер картки'),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _expiryDateController,
                      decoration: InputDecoration(labelText: 'Дата (мм/рр)'),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: _cvvController,
                      decoration: InputDecoration(labelText: 'CVV'),
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ],
            // Вибір способу доставки
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Виберіть спосіб доставки:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
            // Пункти вибору способу доставки
            ListTile(
              title: Text('Самовивіз'),
              leading: Radio(
                value: 'pickup',
                groupValue: _deliveryMethod, // Поточне значення вибору способу доставки
                onChanged: (value) {
                  setState(() {
                    _deliveryMethod = value as String;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Доставка до дверей'),
              leading: Radio(
                value: 'home_delivery',
                groupValue: _deliveryMethod, // Поточне значення вибору способу доставки
                onChanged: (value) {
                  setState(() {
                    _deliveryMethod = value as String;
                  });
                },
              ),
            ),
            // Введення адреси доставки, якщо обрано спосіб доставки "Доставка до дверей"
            if (_deliveryMethod == 'home_delivery')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _deliveryAddressController,
                  decoration: InputDecoration(labelText: 'Адреса доставки'),
                ),
              ),
            // Вибір адреси для самовивозу, якщо обрано спосіб доставки "Самовивіз"
            if (_deliveryMethod == 'pickup')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Адреса відділення для самовивозу'),
                  value: null,
                  onChanged: (selectedAddress) {
                    setState(() {
                      _deliveryAddressController.text = selectedAddress!;
                    });
                  },
                  items: _pickupAddresses
                      .map((address) => DropdownMenuItem(
                    child: Text(address),
                    value: address,
                  ))
                      .toList(),
                ),
              ),
            // Кнопка "Оформити замовлення"
            Padding(
              padding: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // Додайте код для оформлення замовлення тут
                },
                child: Text('Оформити замовлення'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
