import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import '../Models/userdata_model.dart';
import '../Utilities/tokenStorage.dart';
import 'OtpScreen.dart';


class FullNameScreen extends StatelessWidget {
  final String phoneNumber;
  final String otp;
  final TextEditingController nameController = TextEditingController();

  FullNameScreen({required this.phoneNumber,required this.otp});

  void registerUser(BuildContext context) async {
    final fullName = nameController.text.trim();

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your full name.")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://admin.kushinirestaurant.com/api/login-register/"),
        body: jsonEncode({
          "first_name": fullName,
          "phone_number": phoneNumber,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Save token securely
        final token = data['token']['access'];

        await TokenStorage.saveToken(token);

        // Save user data in UserData singleton
        UserData().name = fullName;
        UserData().phone = phoneNumber;


        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OtpScreen(phoneNumber: phoneNumber, otp: otp)),
        );
        Get.snackbar("Enter otp", "$otp");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to register. Please try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.04),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter Full Name",
                border: UnderlineInputBorder(),
                labelStyle: TextStyle(
                  fontSize: screenWidth * 0.041,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => registerUser(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.017,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}