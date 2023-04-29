import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:app_geo/user/view/mobileView/form/login.dart';
import 'dart:io';
import 'package:app_geo/user/view/mobileView/Components/RecentConnexion.dart';
import 'package:app_geo/user/controller/child.controller.dart';
import 'package:app_geo/user/model/child.model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:app_geo/user/controller/user.controller.dart';

import '../Components/Notification.dart';
import '../Components/waiting.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [HexColor("#E7EFFC"), HexColor("#F3FEEC")],
          // Ajouter des couleurs supplémentaires ici si vous le souhaitez
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
              decoration: BoxDecoration(
                color: HexColor("#F9F6E9").withOpacity(0.8),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 130, 20),
      child: Text(
        "ADD A CHILD",
        textAlign: TextAlign.right,
        style: GoogleFonts.oleoScript(
          fontSize: 25,
          fontStyle: FontStyle.italic,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _ctrCode = TextEditingController();
  final _ctrName = TextEditingController();
  final _ctrAge = TextEditingController();
  final _ctrsex = TextEditingController();
  final _ctrImage = TextEditingController();

  @override
  void dispose() {
    _ctrCode.dispose();
    _ctrName.dispose();
    _ctrAge.dispose();
    _ctrsex.dispose();
    _ctrImage.dispose();

    super.dispose();
  }

  String _password = '';
  String _confirmPassword = '';
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File? imageFile) async {
    if (imageFile == null) {
      return null;
    }

    final ref = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() {});

    if (snapshot.state == TaskState.success) {
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    }

    return 'null';
  }

  Future<String> uploadDefaultImage() async {
    final defaultImageBytes = await rootBundle.load('assets/images/image.png');
    final metadata = SettableMetadata(contentType: 'image/png');

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask =
        storageRef.putData(defaultImageBytes.buffer.asUint8List(), metadata);

    await uploadTask.whenComplete(() {});

    return await storageRef.getDownloadURL();
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
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7)),
              child: TextFormField(
                controller: _ctrCode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '  Please enter a code';
                  }

                  if (int.tryParse(value) == null) {
                    return '  Code must be numeric';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Code',
                  hintText: 'Create your secret code',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.vpn_key, color: Colors.black),
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
                controller: _ctrName,
                validator: (value) {
                  // add email validation
                  if (value == null || value.isEmpty) {
                    return '  Please enter a name';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your child\'s name',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.person, color: Colors.black),
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
              padding: EdgeInsets.all(3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 5),
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
                            controller: _ctrAge,
                            onChanged: (value) {
                              _password = value;
                            },
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return ' Please enter an age';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Age',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter an age',
                              prefixIcon: const Icon(Icons.calendar_today,
                                  color: Colors.black),
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
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                            cursorColor:
                                Color.fromARGB(255, 67, 67, 67).withOpacity(1),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 5),
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
                            controller: _ctrsex,
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return ' Please enter a sex';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Sex',
                              labelStyle: TextStyle(color: Colors.black),
                              hintText: 'Enter your chhild\'s sex',
                              prefixIcon:
                                  const Icon(Icons.male, color: Colors.black),
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: 250,
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
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        if (_imageFile != null)
                          Image.file(_imageFile!, height: 30, width: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Choose an image',
                                        style: GoogleFonts.oleoScript(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            GestureDetector(
                                              child: Text('Gallery'),
                                              onTap: () {
                                                _pickImage(ImageSource.gallery);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            SizedBox(height: 10),
                                            GestureDetector(
                                              child: Text('Camera'),
                                              onTap: () {
                                                _pickImage(ImageSource.camera);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Text(
                                  'Choose a photo',
                                  style: GoogleFonts.oleoScript(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20, left: 50),
                              child: Icon(
                                Icons.add_a_photo,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _gap(),
            Container(
              padding: EdgeInsets.only(bottom: 20, top: 30),
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      primary: HexColor("#D7C773"),
                      onPrimary: Colors.black,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'ADD',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        String? imageUrl;
                        if (_imageFile == null) {
                          imageUrl = await uploadDefaultImage();
                        } else {
                          imageUrl = await _uploadImage(_imageFile);
                        }

                        final child = Child(
                            Code: int.parse(_ctrCode.text),
                            Name: _ctrName.text,
                            Age: _ctrAge.text,
                            sex: _ctrsex.text,
                            image: imageUrl,
                            parentId: getCurrentUserId());
                        addChild(child);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WaitingPage(id: child.Id)),
                        );
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
