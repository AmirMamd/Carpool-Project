import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:students_carpool/Payment/PaymentCard.dart';
import '../Database/DriverOps.dart';
import '../Database/RequestOps.dart';
import '../Routes/RouteList.dart';
import '../User/Login.dart';
import '/User/Profile.dart';

class CustomItem {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  String status;
  String meetingPoint;
  DateTime date;


  CustomItem(this.id, this.imageUrl, this.name, this.price, this.status, this.meetingPoint, this.date);
}

class DriverDetails{
  final String? id;
  final String fullname;
  final String email;
  final int phoneNumber;
  DriverDetails({required this.id,required this.fullname,required this.email,required this.phoneNumber});
}

class StatusHistory extends StatefulWidget {
  final String? userId;
  final String? driverId;
  final Future<String?> uid;

  StatusHistory({required this.userId,required this.driverId,required this.uid});

  @override
  State<StatusHistory> createState() => _StatusHistoryState();
}

class _StatusHistoryState extends State<StatusHistory> {
  bool loading = true;
  late Stream<QuerySnapshot> statusStream;
  late List<CustomItem> filteredItems = [];
  late List<CustomItem> customItems = [];
  late DriverDetails? driverDetails;
  String query = '';

  @override
  void initState() {
    super.initState();
    statusStream = FirebaseFirestore.instance
        .collection('Requests')
        .where('userId', isEqualTo: widget.userId)
        .snapshots();
    fetchRequests();
  }

  void fetchRequests() async {
    List<Map<String, dynamic>>? requestsData = await RequestOps.getRequests(widget.userId);
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
        loading = false;
      });
    } else {
      // Handle the case when requestsData is null
    }
  }
  void _showBottomSheet() async {
    driverDetails = await DriverOps.getDriverDetailsById(widget.driverId);

    showModalBottomSheet(
      
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.pink,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.pink, width: 1.0),
          ),
          height: 200,
          child: driverDetails != null ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  driverDetails!.fullname,
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
              SizedBox(height: 4.0),
              Center(
                child: Text(
                  driverDetails!.email,
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ),
              SizedBox(height: 4.0),
              Center(
                child: Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${driverDetails!.phoneNumber}',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ) : Center(
            // Show a message if driver details are not available
            child: Text(
              'Driver details not found',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double tileHeight = MediaQuery.of(context).size.height * 0.3;
    if (loading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
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
              SizedBox(width: screenWidth * 0.2),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 27),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(uid: widget.uid),
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
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const RouteList(),
              ),
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
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
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> snapshots = querySnapshot.docs;

                  // Apply search filter directly using the query
                  List<QueryDocumentSnapshot> filteredSnapshots = snapshots; // Show all items if query is empty
                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredSnapshots.length,
                      itemBuilder: (BuildContext context, int index) {
                        var document = filteredSnapshots[index];
                        String id = document.id;
                        DateTime date = document['date'].toDate();
                        String meetingPoint = document['meetingPoint'];
                        String status = document['status'];
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
                                filteredItems[index].imageUrl.startsWith('assets') ?
                                Image.asset(
                                  filteredItems[index].imageUrl,
                                  height: tileHeight * 0.5,
                                  width: screenWidth * 0.3,
                                ) : Image.network(
                                  filteredItems[index].imageUrl,
                                  height: tileHeight * 0.5,
                                  width: screenWidth * 0.3,
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
                                          status,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Icon(
                                          status == "Rejected"
                                              ? Icons.cancel
                                              : status == "Accepted"
                                              ? Icons.check_circle
                                              : status == "Done"
                                              ? Icons.stop_circle
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
                                          meetingPoint,
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
                                      DateFormat('dd/MM/yyyy hh:mm a').format(date),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        ...(status != "Done"
                                            ? [
                                          ElevatedButton.icon(
                                            onPressed: () async {
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
                                        ]
                                            : [
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PaymentCard(requestId: filteredItems[index].id)),
                                              );
                                            },
                                            icon: Icon(Icons.payment,color: Colors.black),
                                            label: Text(
                                              'Pay',
                                              style: TextStyle(fontSize: 14,color: Colors.black),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        SizedBox(width: 8.0),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            _showBottomSheet();
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
              },
            ),
          ],
        ),
      );
    }
  }
}
