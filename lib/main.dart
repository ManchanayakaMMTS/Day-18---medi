// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mediconnect2/Pages/Other/splash_screen.dart';
import 'package:mediconnect2/Pages/Pharmacy/pharmacy_home.dart';
import 'package:mediconnect2/screens/user_profile.dart';
import 'firebase_options.dart';
import 'Pages/Other/loginpage.dart';
import 'Pages/Other/selection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'poppins'),
      debugShowCheckedModeBanner: false,
      // ignore: prefer_const_constructors
      home: SplashScreen(),
    );
  }
}
