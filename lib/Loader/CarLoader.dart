import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Routes/RouteList.dart';

class CarLoader extends StatefulWidget {
  @override
  _CarLoaderState createState() => _CarLoaderState();
}

class _CarLoaderState extends State<CarLoader> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RouteList()), // Replace YourNewPage with your actual page widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFFFFFFFF),
          rightDotColor: const Color(0xFFEA3799),
          size: 150,
        ),
      ),
    );
  }
}
