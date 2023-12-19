import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Firebase/RequestOps.dart';
import '../Firebase/UserOps.dart';
import '../Log/StatusHistory.dart';
import '../User/Login.dart';
import '/Payment/PaymentCard.dart';
import '/User/Profile.dart';
import 'package:students_carpool/Routes/RouteList.dart';


class RequestCart extends StatefulWidget {
  final Location locationItem;
  final DateTime date;
  final String time;
  final String meetingPoint;


  RequestCart({required this.locationItem,required this.date,required this.time,required this.meetingPoint});

  @override
  State<RequestCart> createState() => _RequestCartState();
}

class _RequestCartState extends State<RequestCart> {
  late String? userId;
  @override
  void initState() {
    super.initState();
    initializeUserId();
  }

  Future<void> initializeUserId() async {
    userId = await UserOps.getCurrentUserDocumentId();
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Location locationItem = widget.locationItem;

    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Request Details',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: screenWidth*0.12),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white,size: 27),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    )
                ),
              ),
              IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white,size: 27),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        )
                    );
                  }
              ),
            ],
          ),
          leading:
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.black,
        ),
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Icon(Icons.calendar_today,size: 30),
              subtitle: Center(
                child: Text("${widget.date.toLocal()}".split(' ')[0],
                    style: GoogleFonts.caveat(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    )),
              ),
            ),

            Center(
                child: Text(
                  'Time: ${widget.time}',
                  style: GoogleFonts.patrickHand(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                )),
            Center(
                child: Text(
                  'Price: ${widget.locationItem.price}',
                  style: GoogleFonts.patrickHand(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                )),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 10), // Adjust spacing as needed
                  Text(
                    '${locationItem.name}',
                    style: GoogleFonts.patrickHand(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 10), // Adjust spacing as needed
                  Text(
                    '${widget.meetingPoint}',
                    style: GoogleFonts.patrickHand(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Image.asset(
              '${locationItem.image}',
            ),
            SizedBox(height: screenHeight*0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjust alignment as needed
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Set the button background color
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.patrickHand(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
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
                        RequestOps.createRequestRecord(
                          widget.meetingPoint,
                          widget.date,
                          widget.time,
                          widget.locationItem.image,
                          userId,
                        ).then((_) {
                          // Navigate to the next screen when the request is completed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StatusHistory(UserId: userId),
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink, // Set the button background color
                      ),
                      child: Text(
                        'Proceed To Checkout',
                        style: GoogleFonts.patrickHand(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
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
      )
    );
  }
}
