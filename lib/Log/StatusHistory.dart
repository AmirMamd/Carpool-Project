import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Firebase/DriverOps.dart';
import '../Firebase/RequestOps.dart';
import '../Routes/RouteList.dart';
import '../User/Login.dart';
import '/User/Profile.dart';
import '/Driver/DriverDetails.dart';


class CustomItem {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  String status;
  String meetingPoint;
  DateTime date;

  CustomItem(this.id,this.imageUrl, this.name,this.price,this.status,this.meetingPoint,this.date);
}


class StatusHistory extends StatefulWidget {
  final String? UserId;

  StatusHistory({required this.UserId});

  @override
  State<StatusHistory> createState() => _StatusHistoryState();
}

class _StatusHistoryState extends State<StatusHistory> {
  bool loading=true;
  late Stream<QuerySnapshot> statusStream;
  late List<CustomItem> filteredItems = [];
  late List<CustomItem> customItems = [];
  @override
  void initState(){
    super.initState();
    statusStream = FirebaseFirestore.instance
        .collection('Requests')
        .where('userId', isEqualTo: widget.UserId)
        .snapshots();
    fetchRequests();
  }

  void fetchRequests() async {
    List<Map<String, dynamic>>? requestsData = await RequestOps.getRequests(widget.UserId);
    List<CustomItem> fetchedItems = [];
    if (requestsData != null) {
      for (var requestData in requestsData) {
        String visitedLocationId = requestData['visitedLocationId'];
        Map<String, dynamic>? locationData = await DriverOps.getLocationDetails(visitedLocationId);
        if (locationData != null) {
          fetchedItems.add(CustomItem(
            requestData['requestId'],
            locationData['imageUrl'],
            locationData['name'],
            locationData['price'],
            requestData['status'],
            requestData['meetingPoint'],
            requestData['date'].toDate(), // Convert Timestamp to DateTime
          ));
        }
      }
      setState(() {
        customItems = fetchedItems;
        filteredItems = List.from(customItems);
        loading=false;
      });
    } else {
      // Handle the case when requestsData is null
    }
  }

  void filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = customItems; // Show all items if query is empty
      } else {
        filteredItems = customItems
            .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context){
    double screenWidth = MediaQuery.of(context).size.width;
    double tileHeight = MediaQuery.of(context).size.height*0.3;
    if(loading){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'History Log',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: screenWidth*0.2),
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
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RouteList(),
                )
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body:
        Column(
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
            StreamBuilder<QuerySnapshot>(
                stream: statusStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available.'));
                  } else {
                    return
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var document = snapshot.data!.docs[index];
                            String id = document.id;
                            filteredItems[index].date = document['date'].toDate();
                            filteredItems[index].meetingPoint = document['meetingPoint'];
                            filteredItems[index].status = document['status'];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.pink,
                                  width: 0.8,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(8.0),
                                title: Row(
                                  children: [
                                    Image.asset(
                                      filteredItems[index].imageUrl,
                                      height: tileHeight * 0.5,
                                      width: screenWidth*0.3,
                                    ),
                                    SizedBox(width: 16.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          filteredItems[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            Text(
                                              'Status:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              filteredItems[index].status,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Icon(
                                              filteredItems[index].status == "Rejected"
                                                  ? Icons.cancel
                                                  : filteredItems[index].status == "Accepted"
                                                  ? Icons.check_circle
                                                  : Icons.access_time_filled, // Replace with the appropriate icon for pending status
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Price:',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                              '${filteredItems[index].price}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              filteredItems[index].meetingPoint,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            Icon(
                                              Icons.account_balance_sharp,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          DateFormat('dd/MM/yyyy hh:mm a').format(filteredItems[index].date),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Row(
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () async{
                                                await RequestOps.deleteRequest(id);
                                                setState(() {
                                                  filteredItems.removeWhere((item) => item.id == id);
                                                });
                                              },
                                              icon: Icon(Icons.delete),
                                              label: Text(
                                                'Delete',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 8.0),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DriverDetails()),
                                                );
                                              },
                                              icon: Icon(Icons.drive_eta_outlined),
                                              label: Text(
                                                'Details',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                  }
                }
            )
          ],
        ),
      );
    }

  }
}