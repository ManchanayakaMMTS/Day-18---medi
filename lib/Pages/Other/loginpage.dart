// lib/Pages/Other/login_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Pages/Customer/registration_page_c.dart';
import '/Pages/Pharmacy/registration_page_p.dart';
import '/Pages/Customer/customer_home.dart';
import '/Pages/Pharmacy/pharmacy_home.dart';
import '/Models/user_type.dart';

class UserDetails {
  final String email;
  final String firstName;
  final String lastName;
  final UserType userType;

  UserDetails({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.userType}) : super(key: key);

  final UserType userType;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      // Continue with your existing sign-in logic
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Get user details from the database based on the entered email
      UserDetails? userDetails =
          await getUserDetails(emailController.text.trim());

      if (userDetails == null) {
        // User not found in the database
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not found. Please check your credentials.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Check if the user's userType matches the selected userType
      if (userDetails.userType != widget.userType) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Invalid user type. Please select the correct user type.'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Authentication and user type check successful
      print('User ID: ${userCredential.user?.uid}');

      // Display success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in successful!'),
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate to the respective home page based on user type
      if (widget.userType == UserType.Customer) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerHomePage()),
        );
      } else if (widget.userType == UserType.Pharmacy) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PharmacyHomePage()),
        );
      }

      // You can add more roles as needed
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid email or password.'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<UserDetails?> getUserDetails(String email) async {
    try {
      // Use Firestore to get user details based on the email
      QuerySnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore
          .instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        // User not found in the database
        return null;
      }

      var userData = userSnapshot.docs.first.data();

      // Return user details as UserDetails object
      return UserDetails(
        email: userData['email'],
        firstName: userData['firstName'],
        lastName: userData['lastName'],
        userType: userTypeFromString(userData['userType']),
      );
    } catch (e) {
      // Handle any potential errors here
      print("Error fetching user details: $e");
      return null;
    }
  }

  UserType userTypeFromString(String userType) {
    switch (userType) {
      case 'Customer':
        return UserType.Customer;
      case 'Pharmacy':
        return UserType.Pharmacy;
      default:
        return UserType
            .Customer; // Default to Customer if the userType is not recognized
    }
  }

  void navigateToRegistrationPage() {
    if (widget.userType == UserType.Customer) {
      // Navigate to the customer registration page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPageC()),
      );
    } else {
      // Navigate to the pharmacy registration page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPageP()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A651),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigate to the registration page based on user type
                            navigateToRegistrationPage();
                          },
                          child: Text(
                            " Register now",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: LoginPage(
          userType: UserType.Pharmacy), // You can set UserType.Customer as well
    ),
  );
}
