import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/Loader/CarLoader.dart';
import 'package:students_carpool/Routes/RouteList.dart';
import 'Login.dart';
import '/FireBase/firebase_auth_services.dart';

class Register1 extends StatefulWidget {
  const Register1({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register1> {
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  bool isTypingInPassword = false;
  String errorMessage = '';
  bool hasError = false;
  final RegExp emailRegex = RegExp(
    r'^[0-9]{2}[a-zA-Z][0-9]{4}@eng\.asu\.edu\.eg$',
  );
  final FirebaseAuthService _auth = new FirebaseAuthService();
  late FirebaseFirestore firestore;
  late CollectionReference users;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  bool isSigningUp = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _numberController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    users = firestore.collection('Users');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double modalHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: Text(
              'Login',
              style: GoogleFonts.patrickHand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          )
        ],
      ),
      body:
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
      child:
        Center(
          child:
          Column(
            children:[
              SizedBox(height: modalHeight*0.1),
              isTypingInPassword
                  ? Image.asset('assets/LoginCover.png', height: modalHeight * 0.2)
                  : Image.asset('assets/LoginUncover.png', height: modalHeight * 0.2),
              // SizedBox(height: modalHeight*0.23),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: emailFocusNode,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'email@eng.asu.edu.eg',
                    labelText: 'Email',
                    hintStyle: GoogleFonts.caveat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // Set your desired text color here
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: (text) {
                    setState(() {
                      isTypingInPassword = text.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Password',
                    labelText: 'Password',
                    hintStyle: GoogleFonts.caveat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // Set your desired text color here
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _fullNameController,
                  focusNode: fullNameFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    labelText: 'Full Name',
                    hintText: 'Full Name',
                    hintStyle: GoogleFonts.caveat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // Set your desired text color here
                  ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _numberController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Phone Number',
                    labelText: 'Phone Number',
                    hintStyle: GoogleFonts.caveat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // Set your desired text color here
                  ),
                ),
              ),
              Text(
                hasError? errorMessage : '',
                style: GoogleFonts.patrickHand(
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: modalHeight*0.05),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  ElevatedButton(
                    onPressed: () {
                      _signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink, // Set the button background color
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.patrickHand(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ),
    ),
    );
  }
  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String fullname = _fullNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    int number = int.parse(_numberController.text);
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        isSigningUp = false;
        errorMessage = "email must be xxpxxxx@eng.asu.edu.eg";
        hasError = true;
      });
      return;
    }

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      if (user != null) {
        await users.doc(user.uid).set({
          'email': email.toLowerCase(),
          'fullName': fullname,
          'password': sha256.convert(utf8.encode(password)).toString(),
          'phoneNumber': number,
          // Other user-related data if needed
        });
        setState(() {
          isSigningUp = false;
          hasError = false;
          errorMessage = "";
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarLoader()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isSigningUp = false;
        hasError = true;
        errorMessage = e.message ?? "An error occurred";
        // e.message contains the error message from FirebaseAuthException
      });
    }
  }
}


