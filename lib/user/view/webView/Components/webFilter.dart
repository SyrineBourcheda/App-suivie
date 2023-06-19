import 'package:app_geo/user/view/mobileView/Components/ChildTraker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'instructionFilter.dart';

class WebFilterWeb extends StatefulWidget {
  @override
  _WebFilterWeb createState() => _WebFilterWeb();
}

class _WebFilterWeb extends State<WebFilterWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#87B1F8'),
        toolbarHeight: 60,
        title: Container(
          padding: const EdgeInsets.only(left: 40),
          child: const Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              Text(
                'Web Filter',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(30),
          padding: const EdgeInsets.all(10),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 50)),
                    Text(
                      "We would like to bring to your attention that children may have easy  access to numerous inappropriate  websites that may contain violent ,  explicit, or age-inappropriate   content. Therefore, it is crucial that  you keep an eye on your child's  internet usage and take measures  to safeguard their online safety.  We suggest that you set up parenta  controls on their devices to help  restrict access to inappropriate content. To do this, you can follow the step  below:",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 70)),
                    Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              primary: HexColor("#87B1F8"),
                              onPrimary: Colors.black,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/instruction');
                            },
                            child: const Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 20, bottom: 20),
                                child: Text("Follow steps"))))
                  ])),
        ),
      ),
    );
  }
}
