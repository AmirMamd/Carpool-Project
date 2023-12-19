import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:students_carpool/User/Register1.dart';
import 'package:students_carpool/Routes/RouteList.dart';
import '/Firebase/firebase_auth_services.dart';
import '../Loader/CarLoader.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isTypingInPassword = false;
  bool hasError = false;
  String errorMessage = '';

  final FirebaseAuthService _auth = new FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    labelText: "Email",
                    hintText: 'email@eng.asu.edu.eg',
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
                    labelText: 'Password',
                    hintText: 'Password',
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
                hasError? errorMessage : "",
                style: GoogleFonts.patrickHand(
                  textStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: modalHeight*0.1),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    _signIn();
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
  void _signIn() async {
    setState(() {
      isSigningIn = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      setState(() {
        isSigningIn = false;
      });

      if (user != null) {
        setState(() {
          hasError = false;
          errorMessage = '';
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CarLoader()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isSigningIn = false;
        hasError = true;
        errorMessage = 'Error signing in: ${e.message}';
      });
    }
  }

}
