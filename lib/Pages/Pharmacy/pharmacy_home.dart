import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class PharmacyHomePage extends StatefulWidget {
  const PharmacyHomePage({Key? key}) : super(key: key);

  @override
  _PharmacyHomePageState createState() => _PharmacyHomePageState();
}

class _PharmacyHomePageState extends State<PharmacyHomePage> {
  String pharmacyName = '';

  @override
  void initState() {
    super.initState();
    getPharmacyInformation();
  }

  Future<void> getPharmacyInformation() async {
    try {
      User? currentUser = await FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: currentUser.email!.toLowerCase())
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);

        if (userSnapshot.exists) {
          var userData = userSnapshot.data() as Map<String, dynamic>;

          // Check userType and additional fields for pharmacy
          if (userData['userType'] == 'Pharmacy') {
            setState(() {
              pharmacyName = userData['firstName'];
            });
          } else {
            print("User is not a pharmacy");
          }
        } else {
          print("User not found in the database");
        }
      } else {
        print("Current user is null");
      }
    } catch (e) {
      print("Error fetching user information: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacy Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement logout functionality
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Pharmacy Home Page, $pharmacyName!',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            MedicineRequestList(pharmacyName: pharmacyName),
          ],
        ),
      ),
    );
  }
}

class MedicineRequestList extends StatelessWidget {
  final String pharmacyName;

  MedicineRequestList({Key? key, required this.pharmacyName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('MedicineRequests')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var requests = snapshot.data!.docs;

        return Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('PharmacyResponses')
                .where('pharmacyName', isEqualTo: pharmacyName)
                .snapshots(),
            builder: (context, responseSnapshot) {
              if (!responseSnapshot.hasData) {
                return CircularProgressIndicator();
              }

              var respondedRequests = responseSnapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  var request = requests[index].data() as Map<String, dynamic>;
                  var hasResponse = respondedRequests.any((response) =>
                      response['customerEmail'] == request['customerEmail'] &&
                      response['medicine'] == request['medicine']);

                  // Only show the request tile if there is no response or the response indicates that the pharmacy has the medicine.
                  if (!hasResponse) {
                    return MedicineRequestTile(
                        request: request, pharmacyName: pharmacyName);
                  } else {
                    return SizedBox(); // You can return an empty widget for requests that have been responded to.
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

class MedicineRequestTile extends StatelessWidget {
  final Map<String, dynamic> request;
  final String pharmacyName;

  MedicineRequestTile({required this.request, required this.pharmacyName});

  @override
  Widget build(BuildContext context) {
    String medicine = request['medicine'] ?? '';
    String customerName = request['customerName'] ?? '';
    String customerEmail = request['customerEmail'] ?? '';
    Timestamp timestamp = request['timestamp'] ?? Timestamp(0, 0);

    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.yMMMEd().add_jms().format(dateTime);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Medicine: $medicine'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Name: $customerName'),
            Text('Customer Email: $customerEmail'),
            Text('Posted Time: $formattedTime'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                showPharmacyResponseDialog(context, customerEmail, medicine);
              },
              child: Text('Respond'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showPharmacyResponseDialog(
      BuildContext context, String customerEmail, String medicine) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Respond to Medicine Request'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Medicine: $medicine'),
              Text('Customer Email: $customerEmail'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Implement logic to update pharmacy response in Firestore
                updatePharmacyResponse(customerEmail, medicine, true);
                Navigator.pop(context);
              },
              child: Text('We Have'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement logic to update pharmacy response in Firestore
                updatePharmacyResponse(customerEmail, medicine, false);
                Navigator.pop(context);
              },
              child: Text("Don't Have"),
            ),
          ],
        );
      },
    );
  }

  void updatePharmacyResponse(
      String customerEmail, String medicine, bool haveMedicine) {
    try {
      // Add a new document to the PharmacyResponses collection
      FirebaseFirestore.instance.collection('PharmacyResponses').add({
        'customerEmail': customerEmail,
        'medicine': medicine,
        'pharmacyName': pharmacyName,
        'hasMedicine': haveMedicine,
      });
    } catch (e) {
      print("Error updating pharmacy response: $e");
    }
  }
}
