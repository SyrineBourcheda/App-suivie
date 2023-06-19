/*import 'package:app_geo/user/controller/user.controller.dart';
import 'package:app_geo/user/view/mobileView/form/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_geo/user/view/mobileView/form/addChild.dart';

import '../../../model/child.model.dart';

class RecentConnnexion extends StatelessWidget {
  const RecentConnnexion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Childs')
              .where("ParentId", isEqualTo: getCurrentUserId())
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final children = snapshot.data!.docs;
              return ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
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
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text(
                                  "Recent Connexion",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.oleoScript(
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 20, 10),
                                child: Text(
                                  "Click on your child's profil or add a child",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.oleoScript(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      color:
                                          HexColor("#000000").withOpacity(0.4)),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(2),
                                  itemCount: children.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(height: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final child = children[index];
                                    return InkWell(
                                      onTap: () {
                                        if (index == children.length) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddChild()));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Login()));
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Hero(
                                              tag: index,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      7,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  decoration: BoxDecoration(
                                                    color: HexColor('#F5F2E0'),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 198, 196, 196),
                                                        blurRadius: 6.0,
                                                        spreadRadius: 2.0,
                                                        offset: Offset(2, 2.0),
                                                      )
                                                    ],
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          child["image"]),
                                                      //fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 60, top: 10),
                                              child: Text(
                                                child["Name"],
                                                style: GoogleFonts.oleoScript(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic,
                                                  color: HexColor("#000000")
                                                      .withOpacity(.5),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])),
                  ),
                ],
              );
            }
          }),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddChild()),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: HexColor("#D7C773"),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
*/

import 'package:app_geo/user/controller/user.controller.dart';
import 'package:app_geo/user/view/mobileView/Components/waiting.dart';
import 'package:app_geo/user/view/mobileView/form/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_geo/user/view/mobileView/form/addChild.dart';

import '../../../model/child.model.dart';

class RecentConnnexion extends StatelessWidget {
  RecentConnnexion({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Childs')
              .where("ParentId", isEqualTo: getCurrentUserId())
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final List<Child> children = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Child(
                  Id: data['Id'],
                  Name: data['Name'],
                  Code: data['Code'],
                  Age: data['Age'],
                  sex: data['sex'],
                  image: data['image'],
                  parentId: data['parentId'],
                  status: data['status'],
                  lat: data['lat'],
                  lng: data['lng'],
                  positionTime: data['positionTime'],
                );
              }).toList();
              final List<String?> childrenName =
                  children.map((child) => child.Name).toList();
              childrenName.add("AddChild");
              final List<String?> _images =
                  children.map((child) => child.image).toList();
              _images.add(
                  "https://cdn-icons-png.flaticon.com/512/4677/4677490.png");

              return ListView(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
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
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text(
                                  "Recent Connexion",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.oleoScript(
                                    fontSize: 30,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 20, 20, 10),
                                child: Text(
                                  "Click on your child's profil or add a child",
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.oleoScript(
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic,
                                      color:
                                          HexColor("#000000").withOpacity(0.4)),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(2),
                                  itemCount: childrenName.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const SizedBox(height: 10),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        if (index == childrenName.length - 1) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddChild()));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      WaitingPage(
                                                          id: children[index]
                                                              .Id)));
                                          print(children[index].Code);
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Hero(
                                              tag: index,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(20.0),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    7,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#F5F2E0'),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 198, 196, 196),
                                                      blurRadius: 6.0,
                                                      spreadRadius: 2.0,
                                                      offset: Offset(2, 2.0),
                                                    )
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    _images[index]!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 55),
                                              child: Text(
                                                childrenName[index]!,
                                                style: GoogleFonts.oleoScript(
                                                  fontSize: 20,
                                                  fontStyle: FontStyle.italic,
                                                  color: HexColor("#000000")
                                                      .withOpacity(.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ])),
                  ),
                ],
              );
            }
          }),
    );
  }
}
