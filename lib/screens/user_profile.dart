import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icons/PLus.svg",
                  width: 18.70267105102539,
                  height: 18.677562713623047,
                ),
                const SizedBox(width: 8.0),
                const Text(
                  "MediConnect",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SvgPicture.asset(
              "assets/icons/user.svg",
              width: 88,
              height: 88,
            ),
            const SizedBox(height: 16.0),
            const Column(
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Set font color to black
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "john.doe@example.com",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/pharmacy.svg",
                      height: 28,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      "Saved Pharmacies",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Set font color to black
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/XMLID_24.svg",
                      height: 28,
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      "Saved Medicine",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Set font color to black
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Medicine History screen
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 40),
                    primary: Colors.lightGreen[50], // Very light green
                    onPrimary: Colors.black, // Set text color to black
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.history,
                          color: Colors.black), // Set icon color to black
                      const SizedBox(width: 8.0),
                      Text('Medicine History',
                          style: TextStyle(
                              color: Colors.black)), // Set text color to black
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Pre Orders screen
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 40),
                    primary: Colors.lightGreen[50], // Very light green
                    onPrimary: Colors.black, // Set text color to black
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag,
                          color: Colors.black), // Set icon color to black
                      const SizedBox(width: 8.0),
                      Text('Pre orders',
                          style: TextStyle(
                              color: Colors.black)), // Set text color to black
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to My Favourites screen
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 40),
                    primary: Colors.lightGreen[50], // Very light green
                    onPrimary: Colors.black, // Set text color to black
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.favorite,
                          color: Colors.black), // Set icon color to black
                      const SizedBox(width: 8.0),
                      Text('My Favourites',
                          style: TextStyle(
                              color: Colors.black)), // Set text color to black
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Saved Medicine screen
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 40),
                    primary: Colors.lightGreen[50], // Very light green
                    onPrimary: Colors.black, // Set text color to black
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.location_city,
                          color: Colors.black), // Set icon color to black
                      const SizedBox(width: 8.0),
                      Text('Location',
                          style: TextStyle(
                              color: Colors.black)), // Set text color to black
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfilePage(),
  ));
}
