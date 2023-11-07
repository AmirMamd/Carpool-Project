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

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsToFaculty(location: widget.location)),
      );
    }
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
              // Your content here

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
