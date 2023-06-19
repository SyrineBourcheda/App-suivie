import 'dart:async';
import 'package:app_geo/user/view/webView/presentation.dart';
import 'package:app_geo/user/view/webView/review.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';
import 'banner.dart';
import 'Navbar.dart';
import 'contact.dart';
import 'footer.dart';

class HomePageWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveNavBarPage(),
      body: ListView(
        children: [
          Banner(),
          PresentationSection(),
          PresentationSection2(),
          PresentationSection3(),
          PresentationSection4(),
          ReviewsSection(),
          ContactUsSection(),
          Footer(),
        ],
      ),
    );
  }
}

class Banner extends StatefulWidget {
  @override
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  final List<String> images = [
    'assets/images/image3.png',
    'assets/images/image1.png',
    'assets/images/image2.png',
  ];
  int _currentPageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // start the timer to change the current page every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentPageIndex = (_currentPageIndex + 1) % images.length;
      });
    });
  }

  @override
  void deactivate() {
    // stop the timer when the widget is removed from the tree
    _timer?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: HexColor('#EEF2F3').withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        height: 400,
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'The most reliable parental control application',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#221D67'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'AppName allows parents to control screen time, track real-time location, and detect inappropriate content on their children\'s devices.',
                      style: GoogleFonts.oleoScript(
                          fontSize: 20,
                          color: HexColor('#221D67').withOpacity(0.8)),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: AnimatedButton(
                          onPressed: () {
                            // action when the button is pressed
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                    width: 3,
                    height: 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            images[(_currentPageIndex + 1) % images.length]),
                      ),
                      // borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
