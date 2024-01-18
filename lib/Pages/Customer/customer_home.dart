import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

///testing
class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  String userEmail = '';
  String userFirstName = '';
  String userLastName = '';
  String userType = '';
  TextEditingController medicineController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCustomerInformation();
  }

  Future<void> getCustomerInformation() async {
    try {
      User? currentUser = await FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        setState(() {
          userEmail = currentUser.email!;
        });

        DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: userEmail.toLowerCase())
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);

        if (customerSnapshot.exists) {
          var customerData = customerSnapshot.data() as Map<String, dynamic>;
          setState(() {
            userFirstName = customerData['firstName'];
            userLastName = customerData['lastName'];
            userType = customerData['userType'];
          });
        } else {
          print("Customer not found in the database");
        }
      } else {
        print("Current user is null");
      }
    } catch (e) {
      print("Error fetching customer information: $e");
    }
  }

  Future<void> postMedicineRequest() async {
    try {
      await FirebaseFirestore.instance.collection('MedicineRequests').add({
        'customerEmail': userEmail,
        'customerName': '$userFirstName $userLastName',
        'medicine': medicineController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medicine request posted successfully!'),
          duration: Duration(seconds: 3),
        ),
      );

      // Clear the medicine controller after posting
      medicineController.clear();
    } catch (e) {
      print("Error posting medicine request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Home Page'),
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
              'Welcome to Customer Home Page!',
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              'Customer Name: ${userFirstName ?? ''} ${userLastName ?? ''}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'User Type: ${userType ?? ''}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: MedicineRequestList(userEmail: userEmail),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  showAddMedicineRequestDialog();
                },
                child: Text('Add New Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddMedicineRequestDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Medicine Request'),
          content: TextField(
            controller: medicineController,
            decoration: InputDecoration(
              hintText: 'Enter medicine name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                postMedicineRequest();
                Navigator.pop(context);
              },
              child: Text('Post Request'),
            ),
          ],
        );
      },
    );
  }
}

class MedicineRequestList extends StatelessWidget {
  final String userEmail;

  MedicineRequestList({Key? key, required this.userEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('MedicineRequests')
          .where('customerEmail', isEqualTo: userEmail)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No medicine requests found.');
        }

        var requests = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine Requests:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  var request = requests[index].data() as Map<String, dynamic>;
                  return MedicineRequestTile(request: request);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MedicineRequestTile extends StatelessWidget {
  final Map<String, dynamic> request;

  MedicineRequestTile({required this.request});

  @override
  Widget build(BuildContext context) {
    String medicine = request['medicine'] ?? '';
    Timestamp timestamp = request['timestamp'] ?? Timestamp(0, 0);

    DateTime dateTime = timestamp.toDate();
    String formattedTime = DateFormat.yMMMEd().add_jms().format(dateTime);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text('Medicine: $medicine'),
        subtitle: Text(formattedTime),
        trailing: ElevatedButton(
          onPressed: () {
            showRespondedPharmaciesDialog(
                context, medicine, request['customerEmail']);
          },
          child: Text('View Responded Pharmacies'),
        ),
      ),
    );
  }

  Future<void> showRespondedPharmaciesDialog(
      BuildContext context, String medicine, String customerEmail) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('PharmacyResponses')
          .where('customerEmail', isEqualTo: customerEmail)
          .where('medicine', isEqualTo: medicine)
          .get();

      List<String> respondedPharmacies = [];

      for (var doc in response.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data['hasMedicine'] == true) {
          respondedPharmacies.add(data['pharmacyName'] as String);
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Responded Pharmacies for $medicine'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pharmacies that have $medicine:'),
                SizedBox(height: 8.0),
                for (String pharmacyName in respondedPharmacies)
                  Text('- $pharmacyName'),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error fetching responded pharmacies: $e");
    }
  }

  void main() {
    runApp(
      MaterialApp(
        home: CustomerHomePage(),
      ),
    );
  }
}
