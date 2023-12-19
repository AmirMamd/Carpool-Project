import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/User/Login.dart';
import 'DetailsFromFaculty.dart';
import '/User/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String image;
  final String name;
  final double price;

  Location(this.image, this.name,this.price);
}

class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  _RouteListState createState() => _RouteListState();
}
class _RouteListState extends State<RouteList> {
  List<Location> locationItems = [];
  List<Location> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      QuerySnapshot driversSnapshot =
      await FirebaseFirestore.instance.collection('Drivers').get();

      List<Location> fetchedItems = [];

      for (QueryDocumentSnapshot driverDoc in driversSnapshot.docs) {
        QuerySnapshot locationsSnapshot = await FirebaseFirestore.instance
            .collection('Drivers')
            .doc(driverDoc.id)
            .collection('VisitedLocations')
            .get();

        // Iterate through locations and add them to the list
        locationsSnapshot.docs.forEach((locationDoc) {
          String imageUrl = locationDoc['imageUrl'];
          String name = locationDoc['name'];
          double price = locationDoc['price'].toDouble();

          fetchedItems.add(Location(imageUrl, name, price));
        });
      }

      setState(() {
        locationItems = fetchedItems;
        filteredItems = locationItems;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = locationItems; // Show all items if query is empty
      } else {
        filteredItems = locationItems
            .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Routes',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(width: screenWidth*0.30),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white,size: 27),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  )
              ),
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white,size: 27),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  )
                );
              }
            ),
          ],
        ),
        leading:
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: TextField(
              onChanged: (query) {
                filterItems(query);
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length, // Use filteredItems
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title:
                    Row(
                      children: [
                        Image.asset(
                          filteredItems[index].image,
                          height: 75,
                          width: 75,
                        ),
                        SizedBox(width: 20),
                        Text(
                          filteredItems[index].name,
                          style: GoogleFonts.caveat(
                            textStyle: TextStyle(
                              color: Colors.pink,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  tileColor: Colors.black,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsFromFaculty(locationItem: filteredItems[index]),
                      )
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

