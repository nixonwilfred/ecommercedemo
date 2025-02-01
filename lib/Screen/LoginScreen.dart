import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Services/FetchUserProfile.dart';
import '../Services/verify_user.dart';
import '../Utilities/tokenStorage.dart';
import 'FullNameScreen.dart';
import 'OtpScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();

  void verifyPhoneNumber(BuildContext context) async {
    final phoneNumber = mobileController.text.trim();

    // Step 1: Validate phone number
    if (phoneNumber.isEmpty || !RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have not entered a valid 10-digit phone number.")),
      );
      return;
    }

    try {
      // Step 2: Call Verify User API
      final response = await verifyUser(phoneNumber);

      if (response != null) {
        final otp = response['otp'];
        final isUser = response['user'];

        if (isUser) {
          // Step 3: Save Token for Existing User
          final token = response['token']['access'];
          await fetchUserProfile();
          await TokenStorage.saveToken(token); // Save the token securely

          Get.snackbar("Enter otp", "$otp",snackPosition: SnackPosition.BOTTOM,duration: Duration(seconds:2));
          Get.offAll(() => OtpScreen(phoneNumber: phoneNumber, otp: otp));
        } else {

          Get.to(() => FullNameScreen(phoneNumber: phoneNumber,otp: otp,));
        }
      } else {
        // Handle null response from API
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch data. Please try again.")),
        );
      }
    } catch (e) {
      // Handle exceptions
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08, vertical: screenHeight * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Login',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                "Let's Connect with Demo!",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // Phone number input
              Row(
                children: [
                  Container(
                    width: screenWidth * 0.15,
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "+91",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter Phone",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => verifyPhoneNumber(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Continue',
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
      ),
    );
  }
}
