import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/Routes/RouteList.dart';
import '../Service/RequestService.dart';
import '../User/Login.dart';
import 'DetailsFromFaculty.dart';
import '/User/Profile.dart';
import '/Cart/RequestCart.dart';

class DetailsToFaculty extends StatefulWidget {
  final Location locationItem;
  final List<DriverPrice> driverPriceList;
  final Future<String?> uid;

  DetailsToFaculty({required this.locationItem,required this.driverPriceList,required this.uid});

  @override
  State<DetailsToFaculty> createState() => _DetailsToFacultyState();
}

class _DetailsToFacultyState extends State<DetailsToFaculty> {

  DateTime selectedDate = DateTime.now();

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DetailsFromFaculty(locationItem: widget.locationItem,uid: widget.uid)),
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
  int _selectedIndex =1;

  void _showBottomSheet() async {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: widget.driverPriceList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  _showSelectionBottomSheet(widget.driverPriceList[index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.pink, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.driverPriceList[index].driverName,
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Center(
                        child: Text(
                          widget.driverPriceList[index].email,
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
                            '${widget.driverPriceList[index].visitedLocationPrice} EGP',
                            style: TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showSelectionBottomSheet(DriverPrice selectedDriver) {
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
                      'To Gate 3',
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
                  bool isTimeValid = RequestService.checkTimeFrom(selectedDate, "7:30 AM");

                  if (isTimeValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestCart(
                          locationItem: widget.locationItem,
                          date: selectedDate,
                          time: "7:30 AM",
                          meetingPoint: "Gate 3",
                          driverId: selectedDriver.driverId,
                          uid: widget.uid // Pass the selected driver details
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
                              "You can only book a ride before 10 PM the day before the request"),
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
                  }
                },
              ),
              ListTile(
                title: Container(
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'To Gate 4',
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
                  bool isTimeValid = RequestService.checkTimeFrom(selectedDate, "7:30 AM");

                  if (isTimeValid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestCart(
                          locationItem: widget.locationItem,
                          date: selectedDate,
                          time: "7:30 AM",
                          meetingPoint: "Gate 4",
                          driverId: selectedDriver.driverId,
                          uid: widget.uid
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
                  Image.asset("assets/FOEASU.jpg",fit: BoxFit.fitHeight,height: modalHeight*0.5),
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
                            MaterialPageRoute(builder: (context) => Profile(uid: widget.uid)),
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
                        "Remember that you will carpool \n            So don't be late! \n   You must book a ride before \n                  10:00 PM \n if you are reserving next day",
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