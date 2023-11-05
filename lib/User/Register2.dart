import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';

class Register2 extends StatefulWidget {
  const Register2({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register2> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double modalHeight = MediaQuery.of(context).size.height*0.5;
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
                'assets/two.png',
                height: modalHeight * 0.65,

              ),
              Text(
                'Step 2',
                style: GoogleFonts.patrickHand(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Password',
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    hintText: 'Phone Number',
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
                      MaterialPageRoute(builder: (context) => Login()),

                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink, // Set the button background color
                  ),
                  child: Text(
                    'Finish',
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

