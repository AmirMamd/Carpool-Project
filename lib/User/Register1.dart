import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/User/Register2.dart';
import 'Login.dart';

class Register1 extends StatefulWidget {
  const Register1({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register1> {
  FocusNode fullNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    fullNameFocusNode.addListener(() {
      if (fullNameFocusNode.hasFocus) {

      }
    });

    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {

      }
    });
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
              Image.asset(
                'assets/one.png',
                height: modalHeight * 0.25,
              ),
              Text(
                'Step 1',
                style: GoogleFonts.patrickHand(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              // SizedBox(height: modalHeight*0.23),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: fullNameFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Full Name',
                    hintStyle: TextStyle(
                      color: Colors.white
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
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // Set your desired text color here
                  ),
                ),
              ),
              SizedBox(height: modalHeight*0.05),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink, // Set the button background color
                    ),
                    child: Text(
                      'Next',
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

