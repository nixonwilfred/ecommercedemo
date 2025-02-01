import 'dart:convert';
import 'package:http/http.dart' as http;
Future<Map<String, dynamic>?> verifyUser(String phoneNumber) async {
  final url = Uri.parse("https://admin.kushinirestaurant.com/api/verify/");
  try {
    final response = await http.post(url,
      body: jsonEncode({"phone_number": phoneNumber}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  } catch (e) {
    print("Error verifying user: $e");
  }
  return null;
}





