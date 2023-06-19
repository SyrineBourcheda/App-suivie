import 'package:app_geo/user/controller/child.controller.dart';
import 'package:app_geo/user/controller/user.controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/MessageController.dart';
import '../../../model/message.model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatEnfant extends StatefulWidget {
  final String? childId;
  @override
  _ChatEnfantState createState() => _ChatEnfantState();

  ChatEnfant({required this.childId});
}

final message =
    FirebaseFirestore.instance.collection('Messages').orderBy('tempsEnvoi');

class _ChatEnfantState extends State<ChatEnfant> {
  String? _id;

  Timestamp lastDisplayedTime = Timestamp.fromMillisecondsSinceEpoch(0);
  int? messageSelectionne;
  String texteAffiche = '';
  String? uid;
  String? NameUser;
  Future<void> getParent(String? id) async {
    // final user = FirebaseAuth.instance.currentUser;
    uid = await getParenyId(id);
  }

  Future<String?> getParentName(String? id) async {
    uid = await getParenyId(id);
    final childSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Id', isEqualTo: uid)
        .get();

    if (childSnapshot.docs.first.exists) {
      NameUser = childSnapshot.docs.first["FullName"];
    }
    return NameUser;
  }

  final messageController = TextEditingController();
  String username = 'Child';
  @override
  void initState() {
    super.initState();
    markAllAsSeen('Parent');
    _id = widget.childId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          getParenyId(_id),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Afficher un indicateur de chargement pendant l'attente
          } else if (snapshot.hasError) {
            return Text(
                'Une erreur s\'est produite'); // Gérer les erreurs éventuelles
          } else {
            // Les futures sont résolus, vous pouvez accéder aux résultats
            final uid = snapshot.data![0]; // Résultat de getParent()sss
            getParentName(uid);
            //   snapshot.data![1]; // Résultat de getParentName()

            final ButtonStyle style = TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            );

            return Scaffold(
              appBar: AppBar(
                backgroundColor: HexColor('#87B1F8'),
                toolbarHeight: 60,
                title: Container(
                  padding: const EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      Padding(padding: EdgeInsets.only(right: 10)),
                      Text(NameUser ?? 'N/N'),
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
                          .where('idEnfant', isEqualTo: _id)
                          .orderBy('tempsEnvoi')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
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
                                                textStyle:
                                                    GoogleFonts.oleoScript(
                                                  fontSize: 18,
                                                ),
                                              )),
                                          if (_showTime)
                                            afficheTempsEnvoi(
                                                tempsEnvoi, sender),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
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
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, right: 0, bottom: 10),
                                            child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: BubbleSpecialThree(
                                                  text: message,
                                                  sent: true,
                                                  seen: isSeen ? true : false,
                                                  color: HexColor('#F1EDED'),
                                                  tail: true,
                                                  isSender: false,
                                                  textStyle:
                                                      GoogleFonts.oleoScript(
                                                    fontSize: 18,
                                                  ),
                                                )),
                                          ),
                                          if (_showTime)
                                            afficheTempsEnvoi(
                                                tempsEnvoi, sender),
                                        ],
                                      ),
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
                        idParent: uid!,
                        idEnfant: _id!,
                        texteMessage: value,
                        sender: username,
                        tempsEnvoi: FieldValue.serverTimestamp());
                    addMessage(msg);

                    messageController.clear();
                  }),
                ],
              ),
            );
          }
        });
  }

  Widget afficheTempsEnvoi(Timestamp tempsEnvoi, String username) {
    String T = "${tempsEnvoi.toDate().hour}:${tempsEnvoi.toDate().minute}";
    if (username == 'Child') {
      return Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Text(T),
      );
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Text(T),
      );
    }
  }
}
