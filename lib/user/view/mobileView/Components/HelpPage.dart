import 'package:app_geo/user/controller/user.controller.dart';
import 'package:app_geo/user/model/user.model.dart';
import 'package:app_geo/user/view/viewEnf/components/chatEnfant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../../controller/help.controller.dart';
import '../../../model/help.model.dart';

class GettingHelp extends StatefulWidget {
  const GettingHelp({super.key});

  @override
  State<GettingHelp> createState() => _GettingHelpState();
}

class _GettingHelpState extends State<GettingHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#87B1F8'),
          toolbarHeight: 60,
          centerTitle: true,
          title: Text(
            'Getting Help',
            style: GoogleFonts.oleoScript(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,

              end: Alignment.bottomCenter,

              colors: [HexColor("#E7EFFC"), HexColor("#F3FEEC")],

              // Ajouter des couleurs supplémentaires ici si vous le souhaitez
            ),
          ),
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 150.0),
                      decoration: BoxDecoration(
                        color: HexColor('#EFF7FA').withOpacity(.8),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 198, 196, 196),
                            spreadRadius: 5,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        // ignore: prefer_const_literals_to_create_immutables

                        children: [
                          //_Logo(),
                          _FormContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _messageController = TextEditingController();

  String _statusMessage = '';
  void sendMail() async {}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        getNomUser(getCurrentUserId()),
        getEmailUser(getCurrentUserId()),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Afficher un indicateur de chargement pendant l'attente
        } else if (snapshot.hasError) {
          return Text(
              'Une erreur s\'est produite'); // Gérer les erreurs éventuelles
        } else {
          // Les futures sont résolus, vous pouvez accéder aux résultats
          final name = snapshot.data![0]; // Résultat de getParent()
          final Email = snapshot.data![1];
          return Container(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Please don't hesitate to contact us if you would like to obtain further details.",
                      style: GoogleFonts.oleoScript(fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor("#FFFFFFF").withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(7)),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        hintText: 'Enter your Message',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon:
                            const Icon(Icons.message, color: Colors.black),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(
                                0.5), // Définit la couleur de la bordure d'erreur
                          ),
                        ),
                      ),
                      cursorColor:
                          Color.fromARGB(255, 67, 67, 67).withOpacity(1),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        primary: HexColor("#87B1F8"),
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {
                        final message = Help_Message(
                          Name: name!,
                          email: Email!,
                          message: _messageController.text,
                        );
                        addHelpMessage(message);
                        _messageController.clear();
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(15), child: Text("Send"))),
                  Text(_statusMessage),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
