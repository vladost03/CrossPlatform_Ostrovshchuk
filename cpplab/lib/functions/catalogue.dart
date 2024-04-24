import 'package:cloud_firestore/cloud_firestore.dart';

class CatalogueService {
  // Метод для отримання всіх продуктів з Firestore
  Future<List<Map<String, dynamic>>> getProducts() async {
    List<Map<String, dynamic>> products = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('products').get();
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> product = doc.data();
        product['id'] = doc.id;
        products.add(product);
      });
    } catch (e) {
      print("Error getting products: $e");
    }
    return products;
  }

  // Метод для отримання продуктів за певною категорією
  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    List<Map<String, dynamic>> products = [];
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('type', isEqualTo: category)
          .get();
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> product = doc.data();
        product['id'] = doc.id;
        products.add(product);
      });
    } catch (e) {
      print("Error getting products by category: $e");
    }
    return products;
  }
}
