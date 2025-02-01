  import 'package:flutter/material.dart';
  import 'package:get/get.dart';

import 'HomePage.dart';


  class OtpScreen extends StatefulWidget {
    final String phoneNumber;
    final String otp;
    OtpScreen({required this.phoneNumber,required this.otp});
    @override
    _OtpScreenState createState() => _OtpScreenState();
  }

  class _OtpScreenState extends State<OtpScreen> {
    final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());

    void verifyOtp() {
      final otp = otpControllers.map((controller) => controller.text).join();
      if ((otp.length == 4)& (otp==widget.otp)) {



        Get.offAll(() => HomePage());
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid 4-digit OTP')),
        );
      }
    }

    void resendOtp() {
      Get.snackbar("Otp resent", "${widget.otp}");


    }

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight=MediaQuery.of(context).size.height;

      return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Text(
                "OTP VERIFICATION",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight*0.03),
              Text(
                "Enter the OTP sent to +91-${widget.phoneNumber}",
                style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey[700]),
              ),
              SizedBox(height:screenHeight*0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: screenWidth * 0.15,
                    child: TextField(
                      onChanged: (value){
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height:  screenHeight*0.07),
              GestureDetector(
                onTap: resendOtp,
                child: Center(
                  child: Text(
                    "Don't receive code? Re-send",
                    style: TextStyle(
                      fontSize: screenWidth * 0.037,
                      color: Colors.grey,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight*0.03,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16),
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
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    }
  }
