import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';

class Footer extends StatelessWidget {
  //final String appName = "appName";
  final String copyRight = "copyright";

  @override
  Widget build(BuildContext context) {
    return Container(
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
        color: Colors.grey[300],
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /*Text(
                  appName,
                  style: GoogleFonts.oleoScript(
                    fontSize: 25,
                    //fontWeight: FontWeight.bold,
                    color: HexColor('#221D67'),
                  ),
                )*/
                /* Image.asset(
                  "assets/images/app-store.jpg",
                  height: 50,
                ),*/
                SizedBox(width: 20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Follow Us',
                  style: GoogleFonts.oleoScript(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    color: HexColor('#221D67'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook,
                      size: 26.0, color: HexColor('#4B88D0')),
                  color: Colors.black,
                  onPressed: () {
                    // open Facebook page
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.instagram,
                      size: 26.0, color: HexColor('#4B88D0')),
                  color: Colors.black,
                  onPressed: () {
                    // open Instagram page
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.linkedin,
                      size: 26.0, color: HexColor('#4B88D0')),
                  color: Colors.black,
                  onPressed: () {
                    // open LinkedIn page
                  },
                ),
              ],
            ),
            // const Center(child: Text("Copyriht")),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
