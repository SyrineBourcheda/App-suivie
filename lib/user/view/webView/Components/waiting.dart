import 'package:app_geo/user/view/mobileView/Components/ChildTraker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'ChildTraker.dart';

class WaitingPageWeb extends StatefulWidget {
  @override
  _WaitingPageWeb createState() => _WaitingPageWeb();
  final String id;
  WaitingPageWeb({required this.id});
}

class _WaitingPageWeb extends State<WaitingPageWeb> {
  String? _id;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Childs')
            .where('Id', isEqualTo: _id)
            .where('status', isEqualTo: 'connecté')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,

                  end: Alignment.bottomCenter,

                  colors: [
                    HexColor('#4B88D0').withOpacity(0.1),
                    HexColor('#EEF2F3').withOpacity(0.9)
                  ],

                  // Ajouter des couleurs supplémentaires ici si vous le souhaitez
                ),
              ),
              child: Center(
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.all(30),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: HexColor('#EEF2F3').withOpacity(0.8),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 198, 196, 196),
                          spreadRadius: 5,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    "Waiting for child to connect ...",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oleoScript(
                                      fontSize: 30,
                                      fontStyle: FontStyle.italic,
                                      color: HexColor('#221D67'),
                                    ),
                                  ),
                                ),

                                //child: Text("En attente de la connexion de l'enfant..." + _id!),
                              ])),
                    )),
              ),
            );
          } else {
            final data =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            String lat = data['lat'];
            while (lat == '') {
              return Center(child: CircularProgressIndicator());
            }
            return (ChildTrackerWeb(childId: _id));
          }
        },
      ),
    );
  }
}
