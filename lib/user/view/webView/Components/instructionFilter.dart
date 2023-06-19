import 'package:app_geo/user/view/mobileView/Components/ChildTraker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class InstructionWeb extends StatefulWidget {
  @override
  _InstructionWeb createState() => _InstructionWeb();
}

class _InstructionWeb extends State<InstructionWeb> {
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
                Icons.book_online_outlined,
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              Text(
                'Instructions',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          padding: const EdgeInsets.all(10),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "* In your child's smartphone, access google.",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "* Go to settings/privacy and security/secure browsing:choose standard protection:",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent, // couleur de la bordure
                          width: 2.0, // largeur de la bordure
                        ),

                        borderRadius: BorderRadius.circular(
                            8.0), // rayon des coins de la bordure
                      ),
                      child: SizedBox(
                        width: 400.0, // largeur souhaitée
                        height: 400.0, // hauteur souhaitée
                        child: Image.asset("assets/images/SP.jpg"),
                      ), // votre image
                    ),

                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      "* Go back to privacy and security/ Use secure DNS:select ' choose another provider':",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),

                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent, // couleur de la bordure
                          width: 2.0, // largeur de la bordure
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // rayon des coins de la bordure
                      ),
                      child: SizedBox(
                        width: 400.0, // largeur souhaitée
                        height: 400.0,
                        child:
                            Image.asset("assets/images/DNS.jpg"), // votre image
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      "*then choose: CleanBrowsing(Family Filter):",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent, // couleur de la bordure
                          width: 2.0, // largeur de la bordure
                        ),
                        borderRadius: BorderRadius.circular(
                            8.0), // rayon des coins de la bordure
                      ),
                      child: SizedBox(
                        width: 400.0, // largeur souhaitée
                        height: 400.0,
                        child: Image.asset(
                            "assets/images/CLEANBROWSING.jpg"), // votre image
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      "* Now your child can surf safely.",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),

                    Container(
                      child: Row(
                        children: [
                          const Icon(Icons.warning),
                          Text(
                            "   Please note that this feature does ",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.oleoScript(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "not replace a daily check of your ",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "child's smartphone.",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oleoScript(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                      ),
                    ),
                  ])),
        ),
      ),
    );
  }
}
