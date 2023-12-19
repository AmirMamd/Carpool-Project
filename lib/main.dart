import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'User/Login.dart';
import 'User/Register1.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:FirebaseOptions(apiKey: 'AIzaSyDCTh6Bv0GpIO44Jge1av6y11-bbEZo6RA', appId: '1:335814966004:android:c019450dd1350e96d73ca1', messagingSenderId: '335814966004', projectId: 'carpool-c54db'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double modalHeight = MediaQuery.of(context).size.height*0.45;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
            children:[
            SizedBox(height: modalHeight*0.2),
            Text(
              'Carpool',
              style: GoogleFonts.patrickHand(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
            ),
            Text(
              'Making your rides easier',
              style: GoogleFonts.caveat(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Spacer(),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child:
                Column(
                  children:[

                  Image.asset(
                    'assets/Welcome.png',
                    width: screenWidth * 0.7,
                    height: modalHeight * 0.45,
                    fit: BoxFit.fitHeight,
                  ),
                  ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  child: Container(
                    height: modalHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          'Welcome',
                          style: GoogleFonts.patrickHand(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          ' This application aims to \n make your rides from/to \n   Faculty of Engineering \n    Ain Shams University',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
                        children: [
                          Expanded(
                            child: Padding(
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
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                            child:
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Register1()),
                                  );
                                },

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
                        ),
                        ],
                      ),
                      ],
                    ),
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

