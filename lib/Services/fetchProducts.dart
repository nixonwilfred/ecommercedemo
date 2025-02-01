import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Product_model.dart';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(
    Uri.parse('https://admin.kushinirestaurant.com/api/products/'),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

