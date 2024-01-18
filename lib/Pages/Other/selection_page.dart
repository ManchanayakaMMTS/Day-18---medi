// lib/Pages/Other/selection_page.dart

import 'package:flutter/material.dart';
import 'loginpage.dart';
import '/Models/user_type.dart';

void main() {
  runApp(
    MaterialApp(
      home: const SelectionPage(),
    ),
  );
}

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key? key});

  void navigateToLoginPage(UserType userType, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(userType: userType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediConnect'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/pngwing.com.png',
              width: 65,
              height: 65,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'MediConnect',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigateToLoginPage(UserType.Customer, context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen.shade100),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Login as Customer'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                navigateToLoginPage(UserType.Pharmacy, context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.lightGreen.shade100),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Text('Login as Pharmacy'),
            ),
          ],
        ),
      ),
    );
  }
}
