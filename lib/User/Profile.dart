import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:students_carpool/Database/SQLite/DatabaseHelper.dart';


class Profile extends StatefulWidget{

  final Future<String?> uid;

  Profile({required this.uid});

  @override
  _ProfileState createState() => _ProfileState();

}

class UserProfile {
  final String? uid;
  final String email;
  final String fullName;
  final int phoneNumber;

  UserProfile({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  });

  // Convert a Map<String, dynamic> to a UserProfile object
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
    );
  }

  // Convert a UserProfile object to a Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}

class _ProfileState extends State<Profile> {
  late String? userId ="";
  late UserProfile? userProfile = UserProfile(uid: "", email: "", fullName: "", phoneNumber: 0);
  late DatabaseHelper dbHelper = DatabaseHelper();
  @override
  void initState(){
    super.initState();
    initializeUid();

  }
  void initializeUid() async{
    userId = await widget.uid;
    if (userId != null) {
      dbHelper = DatabaseHelper();
      await dbHelper.updateSQLiteFromFirestore(userId);
      fetchUserProfile();
    }
  }
  void fetchUserProfile() async {
    // Fetch user profile data from SQLite based on userId
    if (userId != null) {
      userProfile = await dbHelper.getUserProfile(userId!);
      setState(() {});

    }
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProfile!.fullName,
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userProfile!.email,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${userProfile!.phoneNumber}',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}