import 'package:app_geo/user/controller/user.controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app_geo/user/view/mobileView/Components/RecentConnexion.dart';
import 'package:app_geo/user/view/mobileView/form/signUp.dart';
import '../form/ForgotPwd/EmailForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_geo/user/model/user.model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(top: 150.0),
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
                  child: const Column(
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
          Positioned(
            left: 90.0,
            bottom: 30.0,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.oleoScript(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: HexColor("#000000").withOpacity(0.4)),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: GoogleFonts.oleoScript(
                        fontSize: 17,
                        fontStyle: FontStyle.italic,
                        color: HexColor("#000000")),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                  ),
                ],
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
            "Login",
            textAlign: TextAlign.right,
            style: GoogleFonts.oleoScript(
              fontSize: 45,
              fontStyle: FontStyle.italic,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 120, 20),
          child: Text(
            "Please sign in to continue",
            textAlign: TextAlign.right,
            style: GoogleFonts.oleoScript(
                fontSize: 17,
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;

  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String _statusMessage = '';

  Future<String> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Adresse e-mail non trouvée';
      } else if (e.code == 'wrong-password') {
        return 'Mot de passe invalide';
      } else {
        return 'Une erreur s\'est produite';
      }
    }
  }

  Future<void> _onLogin() async {
    String email = _emailController.text.trim();

    String password = _passwordController.text.trim();

    String result = await signInWithEmail(email, password);
    FirebaseAuth auth = FirebaseAuth.instance;

    setState(() {
      if (result == 'success') {
        auth.authStateChanges().listen((User? user) {
          if (user != null) {
            String? id = getCurrentUserId();

            FirebaseFirestore.instance
                .collection('Users')
                .doc(id)
                .update({'isLoggedIn': true});
          }
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecentConnnexion()));
      } else {
        _statusMessage = result;
      }
    });
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
            Container(
              decoration: BoxDecoration(
                  color: HexColor("#F8F5E6").withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7)),
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  // add email validation

                  if (value == null || value.isEmpty) {
                    return '  Please enter some text';
                  }

                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);

                  if (!emailValid) {
                    return '  Please enter a valid email';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.email, color: Colors.black),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
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
                    const Color.fromARGB(255, 67, 67, 67).withOpacity(1),
              ),
            ),
            _gap(),
            Container(
              decoration: BoxDecoration(
                  color: HexColor("#F8F5E6").withOpacity(0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7)),
              child: TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '  Please enter some text';
                  }

                  if (value.length < 6) {
                    return '  Password must be at least 6 characters';
                  }

                  return null;
                },
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    color: HexColor("#000000"),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(
                          0.5), // Définit la couleur de la bordure d'erreur
                    ),
                  ),
                ),
                cursorColor:
                    const Color.fromARGB(255, 67, 67, 67).withOpacity(1),
              ),
            ),
            _gap(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgotPassword()),
                );
              },
              child: Container(
                padding: const EdgeInsets.only(top: 18.0),

                margin: const EdgeInsets.only(
                    right: 150), // Ajoute un padding de 8 pixels autour du lien

                child: Text(
                  'Forgot your password ?',
                  style: GoogleFonts.oleoScript(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: HexColor("#000000").withOpacity(0.55),
                  ),
                ),
              ),
            ),
            _gap(),
            Container(
              margin: const EdgeInsets.only(left: 170),
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                //width: double.infinity,

                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      primary: HexColor("#D7C773"),
                      onPrimary: Colors.black,
                    ),
                    child: const Padding(
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
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _onLogin();
                      }
                    }),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(_statusMessage),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
