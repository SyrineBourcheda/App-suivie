import 'package:app_geo/user/controller/child.controller.dart';
import 'package:app_geo/user/controller/user.controller.dart';
import 'package:app_geo/user/model/child.model.dart';
import 'package:app_geo/user/view/viewEnf/components/carte.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginEnf extends StatefulWidget {
  const LoginEnf({super.key});

  @override
  State<LoginEnf> createState() => _LoginEnfState();
}

class _LoginEnfState extends State<LoginEnf> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          colors: [HexColor("#E7EFFC"), HexColor("#F3FEEC")],
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
                  margin: EdgeInsets.only(top: 200.0),
                  decoration: BoxDecoration(
                    color: HexColor('#F9F6E9').withOpacity(.8),
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
                      _Logo(),
                      _FormContent(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "LoginEnf",
            textAlign: TextAlign.right,
            style: GoogleFonts.oleoScript(
              fontSize: 45,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 100, 10),
          child: Text(
            "Connect your parent's device",
            textAlign: TextAlign.right,
            style: GoogleFonts.oleoScript(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: HexColor("#000000").withOpacity(0.4)),
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _CodeController = TextEditingController();
  int code = 0;
  Future<void> myMethod() async {
    Child? child = await getChildById(getCurrentUserId());
    if (child != null) {
      code = child.Code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _gap(),
            Container(
              decoration: BoxDecoration(
                  color: HexColor("#F8F5E6").withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7)),
              child: TextFormField(
                controller: _CodeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '  Please enter your code';
                  }

                  if (int.tryParse(value) == null) {
                    return '  Code must be numeric';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Code',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter your code',
                  prefixIcon: const Icon(Icons.key, color: Colors.black),
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
                cursorColor: Color.fromARGB(255, 67, 67, 67).withOpacity(1),
              ),
            ),
            _gap(),
            Container(
              margin: EdgeInsets.only(left: 170),
              padding: EdgeInsets.only(bottom: 20),
              child: SizedBox(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      primary: HexColor("#D7C773"),
                      onPrimary: Colors.black,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5.0),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        QuerySnapshot querySnapshot = await FirebaseFirestore
                            .instance
                            .collection('Childs')
                            .where(FieldPath(['Code']),
                                isEqualTo: int.parse(_CodeController.text))
                            .get();

                        if (querySnapshot.docs.length > 0) {
                          String enfantId = querySnapshot.docs[0].id;

                          FirebaseFirestore.instance
                              .collection('Childs')
                              .doc(enfantId)
                              .update({'status': 'connecté'});

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapForm(id: enfantId)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Code de validation incorrect'),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
