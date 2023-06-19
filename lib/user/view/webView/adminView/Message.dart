import 'package:app_geo/user/controller/comment.controller.dart';
import 'package:app_geo/user/model/help.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/Comment.model.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  String _searchText = '';
  List<Help_Message> messages = [];
  List<Help_Message> filtredMessages = [];
  void sendEmail(String destinationEmail) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: destinationEmail,
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Impossible d\'ouvrir l\'application email';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.1;
    final fontSize = screenWidth * 0.05;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Help_Messages')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              print(snapshot.data!.docs.length);
              messages = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Help_Message(
                  Id: data['Id'],
                  message: data['message'],
                  Name: data['Name'],
                  email: data['email'],
                );
              }).toList();
              if (_searchText.isNotEmpty) {
                filtredMessages = messages.where((message) {
                  final name = message.Name.toLowerCase();
                  final searchText = _searchText.toLowerCase();
                  return name.contains(searchText);
                }).toList();
              } else {
                filtredMessages = messages;
              }

              return CustomScrollView(slivers: [
                SliverAppBar(
                  backgroundColor: HexColor('#4B88D0').withOpacity(.9),
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/image.png',
                        height: 90,
                        width: 80,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 30)),
                      Text(
                        'KidLocator',
                        style: GoogleFonts.oleoScript(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: paddingValue),
                      ),
                      Flexible(
                          child: SizedBox(
                        width: 300,
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              _searchText = text;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search for a User...', // Placeholder
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            prefixIcon: const Icon(Icons.search),
                            filled: true, // Remplir la couleur du fond
                            fillColor: Colors.white,
                          ),
                        ),
                      )),
                    ],
                  ),
                  pinned: true,
                  floating: true,
                ),
                SliverFillRemaining(
                    child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: MediaQuery.of(context).size.width / 9,
                      right: MediaQuery.of(context).size.width / 9,
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: HexColor('#4B88D0').withOpacity(0.5),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color:
                                          HexColor('#EEF2F3').withOpacity(0.5),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Text(
                                              'user name',
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.oleoScript(
                                                fontSize: 20,
                                                color: HexColor('#221D67'),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .1),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Text(
                                              'Messages',
                                              style: GoogleFonts.oleoScript(
                                                fontSize: 20,
                                                color: HexColor('#221D67'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Column(
                                      children: filtredMessages
                                          .map(
                                            (user) => Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    width: 1,
                                                  ),
                                                ),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0),
                                              padding: const EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5,
                                                    child: Text(
                                                      user.Name,
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts
                                                          .oleoScript(
                                                        fontSize: 15,
                                                        color:
                                                            HexColor('#221D67'),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .1),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5.5,
                                                    child: Text(
                                                      user.message,
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts
                                                          .oleoScript(
                                                        fontSize: 15,
                                                        color:
                                                            HexColor('#221D67'),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .1),
                                                  ),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        primary: Colors.white
                                                            .withOpacity(.9),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: FittedBox(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'Send Help',
                                                                style: GoogleFonts
                                                                    .oleoScript(
                                                                  fontSize: 15,
                                                                  color: HexColor(
                                                                      '#221D67'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        sendEmail(user.email);
                                                      }),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ))
              ]);
            
            
            
            
            
            }
          }),
    );
  }
}
