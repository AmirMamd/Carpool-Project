import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/Database/DriverOps.dart';
import 'package:students_carpool/Database/UserOps.dart';
import 'package:students_carpool/Service/RouteService.dart';
import 'package:students_carpool/User/Login.dart';
import 'DetailsFromFaculty.dart';
import '/User/Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  String id;
  String image;
  String name;
  int price;

  Location(this.id,this.image, this.name, this.price);
}

class RouteList extends StatefulWidget {
  const RouteList({Key? key}) : super(key: key);

  @override
  _RouteListState createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  bool loading =true;
  String query ='';
  static final uid = UserOps.getCurrentUserDocumentId();
  late Stream<List<QueryDocumentSnapshot>> statusStream = Stream.empty();
  late Stream<List<QueryDocumentSnapshot>> initialStream = Stream.empty();

  @override
  void initState() {
    super.initState();
    initialStream = DriverOps.getAllVisitedLocationsStream();
    statusStream = RouteService.removeDuplicateLocations(initialStream);
  }



  void filterItems(String newQuery) {
    setState(() {
      query = newQuery; // Update the query directly
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
              SizedBox(width: screenWidth * 0.30),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 27),
                onPressed: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(uid: uid),
                      ),
                    ),
              ),
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white, size: 27),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
              ),
            ],
          ),
          leading: IconButton(
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





            StreamBuilder<List<QueryDocumentSnapshot>>(
              stream: statusStream,
              builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available.'));
                } else {
                  List<QueryDocumentSnapshot> snapshots = snapshot.data!;

                  // Apply search filter directly using the query
                  List<QueryDocumentSnapshot> filteredSnapshots =
                  query.isEmpty
                      ? snapshots // Show all items if query is empty
                      : snapshots.where((snapshot) =>
                      snapshot['name']
                          .toLowerCase()
                          .contains(query.toLowerCase())).toList();

                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredSnapshots.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = filteredSnapshots[index];
                        String id = document.id;

                        String imageUrl = document['imageUrl'] ?? '';
                        String name = document['name'] ?? '';
                        int price = document['price'] ?? 0.0;

                        return ListTile(
                          title:
                          Row(
                            children: [
                              imageUrl.startsWith('assets') ?
                              Image.asset(
                                imageUrl,
                                height: screenHeight*0.1,
                                width: screenWidth*0.2,
                              ) : Image.network(
                                imageUrl,
                                height: screenHeight*0.1,
                                width: screenWidth*0.2,
                              ),
                              SizedBox(width: 20),
                              Text(
                                name,
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
                                  builder: (context) => DetailsFromFaculty(locationItem: Location(id,imageUrl,name,price),uid: uid),
                                )
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      );
  }
}