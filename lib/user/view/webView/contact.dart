import 'dart:async';

import 'package:app_geo/user/view/viewEnf/components/chatEnfant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:bubble/bubble.dart';

import '../../controller/comment.controller.dart';
import '../../model/Comment.model.dart';

class ContactUsSection extends StatefulWidget {
  @override
  _ContactUsSectionState createState() => _ContactUsSectionState();
}

class _ContactUsSectionState extends State<ContactUsSection> {
  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('Comment');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _ctrEmail = TextEditingController();
  final _ctrName = TextEditingController();
  final _ctrMessage = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final comment = Comment(
        Name: _ctrName.text,
        email: _ctrEmail.text,
        message: _ctrMessage.text,
      );
      addComment(comment);
      setState(() {
        _ctrName.text = '';
        _ctrEmail.text = '';
        _ctrMessage.text = '';
      });
    }
  }

  @override
  void dispose() {
    _ctrEmail.dispose();
    _ctrName.dispose();
    _ctrMessage.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
      color: HexColor('#EEF2F3').withOpacity(1),
      child: Column(
        children: [
          Text(
            'Contact Us',
            style: GoogleFonts.oleoScript(
              fontSize: 35,
              //fontWeight: FontWeight.bold,
              color: HexColor('#221D67'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Please fill out the form below to contact us.',
            style: TextStyle(
              fontSize: 16,
              color: HexColor('#221D67'),
            ),
          ),
          const SizedBox(height: 50),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _ctrName,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ctrEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ctrMessage,
                  decoration: const InputDecoration(
                    labelText: 'Message',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a message';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('#4B88D0').withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
