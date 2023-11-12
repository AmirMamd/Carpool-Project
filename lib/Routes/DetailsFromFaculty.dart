import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'DetailsToFaculty.dart';

class DetailsFromFaculty extends StatefulWidget {
  final String location;
  DetailsFromFaculty({required this.location});

  @override
  State<DetailsFromFaculty> createState() => _DetailsState();
}

class _DetailsState extends State<DetailsFromFaculty> {
  int _selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsToFaculty(location: widget.location)),
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
                  Image.asset("assets/FromFaculty.png"),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0,top:10),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 350,top:10),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart_outlined, color: Colors.white,size: 27),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              /*SizedBox(height: modalHeight*0.6),*/
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
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Register2()),
                            );*/
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
