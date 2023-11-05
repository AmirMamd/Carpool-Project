import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/User/Register1.dart';
import 'package:students_carpool/Routes/RouteList.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Login> {
  bool isTypingInPassword = false;

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
                MaterialPageRoute(builder: (context) => Register1()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            child: Text(
              'Regsiter',
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: modalHeight*0.2),
              isTypingInPassword
                  ? Image.asset('assets/LoginCover.png', height: modalHeight * 0.2)
                  : Image.asset('assets/LoginUncover.png', height: modalHeight * 0.2),
              Padding(
                padding: const EdgeInsets.only(bottom:16.0,left:16.0,right: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.white,
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
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // Set your desired text color here
                  ),
                ),
              ),
              SizedBox(height: modalHeight*0.1),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RouteList()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Set the button background color
                  ),
                  child: Text(
                    'Login',
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
}
