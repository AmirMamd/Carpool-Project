import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:students_carpool/Firebase/UserOps.dart';
import 'package:students_carpool/Log/StatusHistory.dart';

import '../Firebase/RequestOps.dart';

class PaymentCard extends StatefulWidget {
  final String asset;
  final DateTime date;
  final String time;
  final String meetingPoint;


  PaymentCard({required this.asset,required this.date,required this.time,required this.meetingPoint});


  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.pink, fontSize: 18),
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.pink),
          labelStyle: const TextStyle(color: Colors.pink),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                    CreditCardWidget(
                      enableFloatingCard: useFloatingAnimation,
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      bankName: 'Bank X',
                      frontCardBorder: Border.all(color: Colors.grey),
                      backCardBorder:  Border.all(color: Colors.grey),
                      showBackView: isCvvFocused,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      backgroundImage:'assets/Card.png',
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            'assets/Mastercard.png',
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              inputConfiguration: const InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Card Number',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                  labelStyle: TextStyle(color: Colors.pink), // Set label color
                                  hintStyle: TextStyle(color: Colors.pink),
                                ),
                                expiryDateDecoration: InputDecoration(
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                  labelStyle: TextStyle(color: Colors.pink), // Set label color
                                  hintStyle: TextStyle(color: Colors.pink),
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                  labelStyle: TextStyle(color: Colors.pink), // Set label color
                                  hintStyle: TextStyle(color: Colors.pink),
                                ),
                                cardHolderDecoration: InputDecoration(
                                  labelText: 'Card Holder',
                                  labelStyle: TextStyle(color: Colors.pink), // Set label color
                                  hintStyle: TextStyle(color: Colors.pink),
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            SizedBox(height: screenHeight*0.1),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _onValidate();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                                  ),
                                  backgroundColor: Colors.pink,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text(
                                  'Validate',
                                  style: GoogleFonts.patrickHand(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');

    } else {
      print('invalid!');
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}