import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/Routes/RouteList.dart';
import 'package:students_carpool/Service/RequestService.dart';
import '../User/Login.dart';
import 'DetailsToFaculty.dart';
import '/User/Profile.dart';
import '/Cart/RequestCart.dart';

class DetailsFromFaculty extends StatefulWidget {
  final Location locationItem;
  DetailsFromFaculty({required this.locationItem});

  @override
  State<DetailsFromFaculty> createState() => _DetailsFromFacultyState();
}

class _DetailsFromFacultyState extends State<DetailsFromFaculty> {
  int _selectedIndex = 0;
  DateTime selectedDate = DateTime.now();

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DetailsToFaculty(locationItem: widget.locationItem)),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'From Gate 3',
                      style: GoogleFonts.patrickHand(
                        textStyle: TextStyle(
                          color: Colors.pink,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  bool isTimeValid = RequestService.checkTimeFrom(selectedDate, "5:30 PM");

                  if (isTimeValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestCart(
                          locationItem: widget.locationItem,
                          date: selectedDate,
                          time: "5:30 PM",
                          meetingPoint: "Gate 3",
                        ),
                      ),
                    );
                  } else {
                    // Show an error pop-up because the time condition is not met
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "You can only book a ride before the request by 5.5 hours."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }// Close the modal
                  // Add your logic here for "From Gate 3"
                },
              ),
              ListTile(
                title: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'From Gate 4',
                      style: GoogleFonts.patrickHand(
                        textStyle: TextStyle(
                          color: Colors.pink,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  bool isTimeValid = RequestService.checkTimeFrom(selectedDate, "5:30 PM");

                  if (isTimeValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestCart(
                          locationItem: widget.locationItem,
                          date: selectedDate,
                          time: "5:30 PM",
                          meetingPoint: "Gate 4",
                        ),
                      ),
                    );
                  } else {
                    // Show an error pop-up because the time condition is not met
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "You can only book a ride before the request by maximum 1 PM same day."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }// Close the modal
                  // Add your logic here for "From Gate 3"
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    double modalHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.asset("assets/FromFaculty.jpeg",fit: BoxFit.fitHeight,height: modalHeight*0.5),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.05,top:modalHeight*0.04),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.75,top:modalHeight*0.04),
                    child: IconButton(
                      icon: Icon(Icons.person, color: Colors.black,size: 27),
                      onPressed: () =>
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth*0.85,top:modalHeight*0.04),
                    child: IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.black,size: 27),
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
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                child: Container(
                  height: modalHeight*0.475,
                  width: screenWidth,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        "Schedule a Ride",
                        style: GoogleFonts.patrickHand(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Text(
                        "Remember that you will carpool \n            So don't be late! \n   You must book a ride before \n                  1:00 PM \n if you are reserving same day",
                        style: GoogleFonts.patrickHand(
                          textStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Icon(Icons.calendar_today,size: 30),
                        subtitle: Center(
                          child: Text("${selectedDate.toLocal()}".split(' ')[0],
                          style: GoogleFonts.caveat(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                ),
                          )),
                        ),
                        onTap: () => _selectDate(context),
                      ),
                      // Add this widget to select a time
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                        ElevatedButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink, // Set the button background color
                          ),
                          child: Text(
                            'Request Order',
                            style: GoogleFonts.patrickHand(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on), // You can change the icon
            label: 'From Faculty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school), // You can change the icon
            label: 'To Faculty',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}
