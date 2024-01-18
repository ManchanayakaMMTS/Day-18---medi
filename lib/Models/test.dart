import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  // Initialize Firebase (make sure you have called Firebase.initializeApp() somewhere in your app)
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    QuerySnapshot usersSnapshot = await firestore.collection('Users').get();

    if (usersSnapshot.docs.isNotEmpty) {
      print('Users in the database:');
      for (QueryDocumentSnapshot user in usersSnapshot.docs) {
        print('User ID: ${user.id}');
        print('Email: ${user['email']}');
        print('First Name: ${user['firstName']}');
        print('Last Name: ${user['lastName']}');
        print('User Type: ${user['userType']}');
        print('---');
      }
    } else {
      print('No users found in the database.');
    }
  } catch (e) {
    print('Error reading from the database: $e');
  }
}
