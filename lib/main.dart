import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Screen/LoginScreen.dart';


void main() {
  runApp(Homepage());
}

class Homepage extends StatelessWidget {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}


