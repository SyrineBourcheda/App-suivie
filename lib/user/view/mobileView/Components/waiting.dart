import 'package:app_geo/user/view/mobileView/Components/ChildTraker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class WaitingPage extends StatefulWidget {
  @override
  _WaitingPage createState() => _WaitingPage();
  final String id;
  WaitingPage({required this.id});
}

class _WaitingPage extends State<WaitingPage> {
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
            return Center(
              child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: HexColor('#F9F6E9').withOpacity(.8),
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
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    "Waiting for child to connect ...",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.oleoScript(
                                      fontSize: 30,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                    ),
                                  )),
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0x99000000)),
                              )

                              //child: Text("En attente de la connexion de l'enfant..." + _id!),
                            ])),
                  )),
            );
          } else {
            final data =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            String lat = data['lat'];
            while (lat == '') {
              return Center(child: CircularProgressIndicator());
            }
            return (ChildTracker(childId: _id));
          }
        },
      ),
    );
  }
}
