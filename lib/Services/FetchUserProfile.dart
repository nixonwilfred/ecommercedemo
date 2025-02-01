import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utilities/tokenStorage.dart';
import '../Models/userdata_model.dart';

Future<void> fetchUserProfile() async {
  final String? token = await TokenStorage.getToken(); // Retrieve stored token

  if (token == null) {
    print("No token found, user may not be logged in.");
    return;
  }

  try {
    final url = Uri.parse("https://admin.kushinirestaurant.com/api/user-data/");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Populate the UserData singleton
      UserData().name = data['name'];
      UserData().phone = data['phone_number'];

      print("User profile fetched successfully.");
    } else {
      print("Failed to fetch user profile: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error fetching user profile: $e");
  }
}
