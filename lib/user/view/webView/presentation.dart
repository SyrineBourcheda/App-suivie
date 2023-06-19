import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';

class PresentationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.locationDot,
                            size: 30.0, color: HexColor('#4B88D0')),
                        color: Colors.black,
                        onPressed: () {
                          // open Instagram page
                        },
                      ),
                      Text(
                        'Track your child’s location',
                        style: GoogleFonts.oleoScript(
                          fontSize: 35,
                          //fontWeight: FontWeight.bold,
                          color: HexColor('#221D67'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'See the exact location of your child so that you know where they walk and what route they take to school ',
                    style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        color: HexColor('#221D67').withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/images/track.jpg',
                  height: 300,
                  width: 300,
                  //fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PresentationSection2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 200),
      height: 400,
      decoration: BoxDecoration(
        color: HexColor('#EEF2F3').withOpacity(0.9),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/images/notif.jpg',
                height: 500,
                width: 1000,
                //fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons
                              .solidBell, // icône de notification pleine
                          size: 30.0, // taille de l'icône
                          color: HexColor('#4B88D0'), // couleur de l'icône
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Receive notifications ',
                          style: GoogleFonts.oleoScript(
                            fontSize: 35,
                            color: HexColor('#221D67'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Set locations such as home or school, and receive automatic notifications when your child arrives or leaves. This way, you\'ll always be in the know without having to check their location constantly. ',
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        color: HexColor('#221D67').withOpacity(0.8),
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
  }
}

class PresentationSection3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0, left: 50),
      height: 400,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons
                            .solidCommentDots, // icône de notification pleine
                        size: 32.0, // taille de l'icône
                        color: HexColor('#4B88D0'), // couleur de l'icône
                        // couleur de l'icône
                      ),
                      Text(
                        ' Contact your child',
                        style: GoogleFonts.oleoScript(
                          fontSize: 35,
                          //fontWeight: FontWeight.bold,
                          color: HexColor('#221D67'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    ' With the help of a chat app, you can easily stay in touch with your child and send them messages at any time of the day. This  helps you stay informed about their daily activities',
                    style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        color: HexColor('#221D67').withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(100),
                child: Image.asset(
                  'assets/images/chat.jpg',
                  height: 500,
                  width: 500,
                  //fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PresentationSection4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 200),
      height: 400,
      decoration: BoxDecoration(
        color: HexColor('#EEF2F3').withOpacity(0.9),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Image.asset(
                'assets/images/SOOS.jpg',
                height: 800,
                width: 500,
                //fit: BoxFit.cover,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons
                              .warning, // icône de notification pleine
                          size: 32.0, // taille de l'icône
                          color: HexColor('#4B88D0'), // couleur de l'icône
                          // couleur de l'icône
                        ),
                        Text(
                          ' Receive an SOS notification',
                          style: GoogleFonts.oleoScript(
                            fontSize: 35,
                            //fontWeight: FontWeight.bold,
                            color: HexColor('#221D67'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      ' if your child encounters an urgent situation or gets lost, they can press an SOS button and you will be notified.',
                      style: GoogleFonts.oleoScript(
                          fontSize: 20,
                          color: HexColor('#221D67').withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
