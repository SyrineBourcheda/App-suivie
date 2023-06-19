import 'package:app_geo/user/view/mobileView/Components/RecentConnexion.dart';
import 'package:app_geo/user/view/mobileView/Components/waiting.dart';
import 'package:app_geo/user/view/mobileView/form/login.dart';
import 'package:app_geo/user/view/viewEnf/form/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_geo/user/view/mobileView/homePage/HomePageMobile.dart';
import 'package:app_geo/user/view/mobileView/form/addChild.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectAs extends StatefulWidget {
  const ConnectAs({super.key});

  @override
  State<ConnectAs> createState() => _ConnectAsState();
}

class _ConnectAsState extends State<ConnectAs> {
  late Widget _initialScreen;

  FirebaseAuth auth = FirebaseAuth.instance;

  void checkUserLoggedIn() async {
    User? user = auth.currentUser;
    if (user != null) {
      // L'utilisateur est connecté
      // Rediriger l'utilisateur vers une autre page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RecentConnnexion()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.4,
            margin: const EdgeInsets.only(left: 30, right: 30),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: HexColor('#F9F6E9').withOpacity(.8),
              boxShadow: [
                const BoxShadow(
                  color: Color.fromARGB(255, 198, 196, 196),
                  spreadRadius: 5,
                  blurRadius: 6,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "Connect As",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.oleoScript(
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 1.9,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(2),
                          itemCount: _images.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                if (index == 0) {
                                  /*Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => _initialScreen));*/
                                  checkUserLoggedIn();
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const LoginEnf()));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Hero(
                                      tag: index,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 30.0,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
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
                                              image: AssetImage(_images[index]),
                                              //fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 70, top: 10),
                                      child: Text(
                                        index == 1 ? "Child" : 'Parent',
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
        ])));
  }
}

final List<String> _images = [
  'assets/images/parent.png',
  'assets/images/child.png'
];
