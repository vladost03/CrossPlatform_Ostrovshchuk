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
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _deliveryAddressController = TextEditingController();
  List<String> _pickupAddresses = []; // Список для зберігання адрес самовивозу

  @override
  void initState() {
    super.initState();
    _fetchRandomAddresses();
  }

  Future<void> _fetchRandomAddresses() async {
    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/?results=6'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        setState(() {
          _pickupAddresses = results.map((result) {
            final city = result['location']['city'];
            final street = result['location']['street']['name'];
            final streetNumber = result['location']['street']['number'];
            return '$city, $street, $streetNumber';
          }).toList();
        });
      } else {
        throw Exception('Failed to load addresses');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = CartService().calculateTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Оформлення замовлення'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Виберіть спосіб оплати:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Виберіть спосіб доставки:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.0),
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
            if (_deliveryMethod == 'home_delivery') // Відображення текстового поля для адреси, якщо вибрано доставку до дверей
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _deliveryAddressController,
                  decoration: InputDecoration(labelText: 'Адреса доставки'),
                ),
              ),
            if (_deliveryMethod == 'pickup') // Відображення випадаючого меню зі згенерованими адресами для самовивозу
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
