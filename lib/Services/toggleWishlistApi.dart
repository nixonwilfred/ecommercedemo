import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> toggleWishlistAPI(String token, int productId) async {
  final url = Uri.parse("https://admin.kushinirestaurant.com/api/add-remove-wishlist/");
  try {
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"product_id": productId}),
    );

    if (response.statusCode == 200 || response.statusCode==201) {
      final data = jsonDecode(response.body);
      return data["message"];
    } else {
      throw Exception("Failed to toggle wishlist status. Response: ${response.body}");
    }
  } catch (e) {
    throw Exception("Error toggling wishlist: $e");
  }
}
