import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/Product_model.dart';

Future<List<Product>> fetchWishlistAPI(String token) async {
  final url = Uri.parse("https://admin.kushinirestaurant.com/api/wishlist/");
  try {
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("Wishlist API Response: $data");
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch wishlist: ${response.body}");
    }
  } catch (e) {
    throw Exception("Error in fetchWishlistAPI: $e");
  }
}
