import 'package:app_geo/user/view/mobileView/form/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordWeb extends StatefulWidget {
  const ForgotPasswordWeb({super.key});

  @override
  State<ForgotPasswordWeb> createState() => _ForgotPasswordWebState();
}

class _ForgotPasswordWebState extends State<ForgotPasswordWeb> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HexColor('#4B88D0').withOpacity(0.1),
            HexColor('#EEF2F3').withOpacity(0.9)
          ],
          // Ajouter des couleurs supplémentaires ici si vous le souhaitez
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              //height: MediaQuery.of(context).size.height / 1.15,
              padding: EdgeInsets.all(10.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              decoration: BoxDecoration(
                color: HexColor('#EEF2F3').withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(99, 97, 97, 0.235),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(3, 3),
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
            "Forgot Password",
            textAlign: TextAlign.right,
            style: GoogleFonts.oleoScript(
              fontSize: 35,
              fontStyle: FontStyle.italic,
              color: HexColor('#221D67'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 120, 20),
          child: Text(
            "Please enter your email address",
            textAlign: TextAlign.right,
            style: GoogleFonts.oleoScript(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: HexColor('#221D67').withOpacity(0.4)),
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

  final _emailController = TextEditingController();
  String _errorMessage = '';

  bool _isLoading = false;

  // fonction pour réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Un e-mail de réinitialisation de mot de passe a été envoyé à $email';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Erreur lors de la réinitialisation du mot de passe : $e';
      });
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
            Container(
              decoration: BoxDecoration(
                  color: HexColor('#EEF2F3').withOpacity(0.6),
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
                controller: _emailController,
                validator: (value) {
                  // add email validation
                  if (value == null || value.isEmpty) {
                    return '  Please enter your email adress';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email adress',
                  labelStyle: TextStyle(
                    color: HexColor('#221D67'),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: HexColor('#221D67'),
                  ),
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
                //width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    primary: HexColor('#4B88D0').withOpacity(0.1),
                    onPrimary: Colors.black,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5.0),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _isLoading = true;
                            });
                            await resetPassword(_emailController.text);
                          }
                        },
                ),
              ),
            ),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}






/**
 * class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _errorMessage = '';
  bool _isResettingPassword = false;

  void _showError(String errorMessage) {
    setState(() {
      _errorMessage = errorMessage;
    });
  }

  void _resetPassword() async {
    setState(() {
      _isResettingPassword = true;
      _errorMessage = '';
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
      setState(() {
        _isResettingPassword = false;
        _errorMessage = 'Un e-mail de réinitialisation de mot de passe a été envoyé à $_email';
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'invalid-email') {
        errorMessage = 'Adresse e-mail invalide';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'Aucun utilisateur trouvé avec cette adresse e-mail';
      } else {
        errorMessage = 'Erreur lors de la réinitialisation du mot de passe';
      }
      _showError(errorMessage);
      setState(() {
        _isResettingPassword = false;
      });
    } catch (e) {
      _showError('Erreur lors de la réinitialisation du mot de passe');
      setState(() {
        _isResettingPassword = false;
      });
    }
 */