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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/pngwing.com.png',
              width: 85,
              height: 85,
            ),
            const SizedBox(height: 10.0),
            const Text(
              'MediConnect',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                navigateToLoginPage(UserType.Customer, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A651),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Login as Customer'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                navigateToLoginPage(UserType.Pharmacy, context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A651),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Login as Pharmacy'),
            ),
          ],
        ),
      ),
    );
  }
}
