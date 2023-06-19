import 'dart:async';

import 'package:app_geo/user/controller/user.controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/MessageController.dart';
import '../../../controller/child.controller.dart';
import '../../../model/message.model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatParent extends StatefulWidget {
  @override
  _ChatParentState createState() => _ChatParentState();
  final String? id;
  ChatParent({required this.id});
}

class _ChatParentState extends State<ChatParent> {
  String? idEnfant;
  Timestamp lastDisplayedTime = Timestamp.fromMillisecondsSinceEpoch(0);
  int? messageSelectionne;
  String texteAffiche = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final messageController = TextEditingController();

  String username = 'Parent';

  @override
  void initState() {
    super.initState();
    markAllAsSeen('Child');
    idEnfant = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait<String?>([
        getNomEnfant(idEnfant),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Une erreur s\'est produite');
        } else {
          final childName = snapshot.data![0];
          final ButtonStyle style = TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          );
          return Scaffold(
            appBar: AppBar(
              backgroundColor: HexColor('#87B1F8'),
              toolbarHeight: 60,
              title: Container(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    Icon(Icons.person),
                    Padding(padding: EdgeInsets.only(right: 10)),
                    Text(
                      // ignore: unnecessary_brace_in_string_interps
                      childName ?? 'N/A',
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: style,
                  onPressed: () {},
                  child: const Icon(Icons.phone),
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: messageCollection
                        .where("idEnfant", isEqualTo: idEnfant)
                        .orderBy('tempsEnvoi')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document =
                              snapshot.data!.docs[index];

                          String message = document['texteMessage'];
                          String id = document['idMessage'];
                          String sender = document['sender'];
                          bool isSeen = document['isSeen'];
                          Timestamp tempsEnvoi =
                              document['tempsEnvoi'] ?? Timestamp.now();
                          bool _showTime = document['showTime'];
                          bool shouldDisplayTime = false;
                          if (lastDisplayedTime.millisecondsSinceEpoch == 0 ||
                              tempsEnvoi.millisecondsSinceEpoch -
                                      lastDisplayedTime
                                          .millisecondsSinceEpoch >=
                                  900000) {
                            shouldDisplayTime = true;
                          }
                          lastDisplayedTime = tempsEnvoi;

                          if (sender == username) {
                            // Le message a été envoyé par l'utilisateur parent
                            return Container(
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: shouldDisplayTime,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Bubble(
                                        child: Text(
                                          tempsEnvoi
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[1]
                                                  .split(":")[0] +
                                              ":" +
                                              tempsEnvoi
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[1]
                                                  .split(":")[1],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (_showTime == false) {
                                          FirebaseFirestore.instance
                                              .collection('Messages')
                                              .doc(id)
                                              .update({'showTime': true});
                                          _showTime = !_showTime;
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('Messages')
                                              .doc(id)
                                              .update({'showTime': false});
                                          _showTime = !_showTime;
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(top: 10),
                                            alignment: Alignment.centerRight,
                                            child: BubbleSpecialThree(
                                              text: message,
                                              sent: true,
                                              seen: isSeen ? true : false,
                                              color: HexColor('#F1EDED'),
                                              tail: true,
                                              textStyle: GoogleFonts.oleoScript(
                                                fontSize: 18,
                                              ),
                                            )),
                                        if (_showTime)
                                          afficheTempsEnvoi(tempsEnvoi),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Le message a été envoyé par l'utilisateur enfant
                            return Container(
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: shouldDisplayTime,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Bubble(
                                        child: Text(
                                          tempsEnvoi
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[1]
                                                  .split(":")[0] +
                                              ":" +
                                              tempsEnvoi
                                                  .toDate()
                                                  .toString()
                                                  .split(" ")[1]
                                                  .split(":")[1],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 0, right: 0, bottom: 10),
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: BubbleSpecialThree(
                                          text: message,
                                          sent: true,
                                          seen: isSeen ? true : false,
                                          color: HexColor('#F1EDED'),
                                          tail: true,
                                          isSender: false,
                                          textStyle: GoogleFonts.oleoScript(
                                            fontSize: 18,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                MessageBar(onSend: (String value) {
                  final Message msg = Message(
                      texteMessage: value,
                      sender: username,
                      idEnfant: idEnfant!,
                      idParent: getCurrentUserId()!,
                      tempsEnvoi: FieldValue.serverTimestamp());
                  addMessage(msg);

                  messageController.clear();
                }),
              ],
            ),
          );
        }
      },
    );
  }

  Widget afficheTempsEnvoi(Timestamp tempsEnvoi) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20),
      child: Text(
        "${tempsEnvoi.toDate().hour}:${tempsEnvoi.toDate().minute}",
      ),
    );
  }
}
