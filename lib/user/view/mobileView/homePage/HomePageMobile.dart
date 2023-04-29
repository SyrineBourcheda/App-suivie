import 'dart:ffi';

import 'package:app_geo/user/view/mobileView/Components/chatParent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_geo/user/view/mobileView/homePage/animation.dart';
import 'package:app_geo/main.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Demo_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [HexColor('#E7EFFC'), HexColor('#F3FEEC')],
          )),
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1000,
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Image.asset('assets/images/image.png')),
              ),
              DelayedAnimation(
                delay: 2000,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 100),
                  child: Text("APP NAME",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oleoScript(
                          textStyle: TextStyle(
                              color: HexColor('#000000').withOpacity(0.7),
                              fontSize: 40,
                              fontWeight: FontWeight.bold))),
                ),
              ),
              DelayedAnimation(
                delay: 3000,
                child: Container(
                  margin: EdgeInsets.only(bottom: 90),
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shadowColor: HexColor('#000000'),
                        elevation: 10,
                        backgroundColor: HexColor("#fbe364"),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(18)),
                    child: Text(
                      'START',
                      style: GoogleFonts.oleoScript(
                          textStyle: TextStyle(
                        color: HexColor('#0E0E0E').withOpacity(0.79),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingPage1(),
                        ),
                      );
                    },
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
