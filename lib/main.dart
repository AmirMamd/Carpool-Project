import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'User/Login.dart';
import 'User/Register1.dart';
void main() {
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Login Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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

