import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';

import '../../controller/comment.controller.dart';

class ReviewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
        future: getPublishedComments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: HexColor('#221D67').withOpacity(0.3),
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, left: 650),
                    child: Text(
                      'Users Reviews',
                      style: GoogleFonts.oleoScript(
                        fontSize: 35,
                        //fontWeight: FontWeight.bold,
                        color: HexColor('#221D67'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var comment in snapshot.data!)
                        Padding(
                          padding: const EdgeInsets.all(60.0),
                          child: SizedBox(
                            width: 300,
                            height: 350,
                            child: Card(
                              color: HexColor('#EEF2F3').withOpacity(1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/avatar2.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      comment['message']!,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.oleoScript(
                                          fontSize: 16,
                                          color: HexColor('#000000')
                                              .withOpacity(0.6)),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      comment['name']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: HexColor('#221D67'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
