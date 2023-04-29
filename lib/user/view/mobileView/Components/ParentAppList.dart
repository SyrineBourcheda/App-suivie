import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:hexcolor/hexcolor.dart';

class ParentAppList extends StatelessWidget {
  final String? Id;

  ParentAppList({required this.Id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Childs Apps",
          textAlign: TextAlign.center,
        ),
        backgroundColor: HexColor('#87B1F8'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('App')
            .where('idEnfant', isEqualTo: Id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement des données.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final appDocs = snapshot.data!.docs;

          if (appDocs.isEmpty) {
            return Center(child: Text("Aucune application trouvée."));
          }

          return ListView.builder(
            itemCount: appDocs.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> appData =
                  appDocs[index].data() as Map<String, dynamic>;

              if (appData['appName'] != null) {
                return Stack(
                  children: [
                    ListTile(
                        contentPadding: EdgeInsets.only(left: 50),
                        title: GestureDetector(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('App')
                                .doc(appData["id"])
                                .update({'isBlocked': true});
                          },
                          child: Text(
                            appData['appName'],
                            style: GoogleFonts.oleoScript(fontSize: 20),
                            textAlign: TextAlign.justify,
                          ),
                        )),
                    Divider(
                      color: Colors.black.withOpacity(.1),
                      thickness: 1,
                      indent: 30,
                      endIndent: 30,
                    ),
                  ],
                );
              } else {
                return ListTile(
                  title: Text('no data'),
                );
              }
            },
          );
        },
      ),
    );
  }
}
