import 'package:app_geo/user/view/webView/homePageWeb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'user/view/mobileView/homePage/HomePageMobile.dart';
import 'package:firebase_database/firebase_database.dart';
import './user/view/mobileView/Components/appBlocking.dart';
import './user/view/mobileView/Components/carte.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBI2LQvV_HZgpn9mSxaK9Ttd2WyZoAQ6_U",
            appId: "1:239226471890:web:7cbb499ea79f5d6ce4b40b",
            messagingSenderId: "239226471890",
            storageBucket: "app-suivie.appspot.com",
            projectId: "app-suivie"));
  } else {
    await Firebase.initializeApp();
  }
  Stripe.publishableKey =
      "pk_test_51MyuqwGRwOwBwhmrw3km2Ot4mJEqksYb4Nfkojr0sWrUZE9Ra4dR8IBioGBJ4RIWKSh7a0JKkuuQXUCy576vTmCE00ZRhPKqM9";

  runApp(ParentApp());
}

class ParentApp extends StatefulWidget {
  @override
  _ParentAppState createState() => _ParentAppState();
}

class _ParentAppState extends State<ParentApp> {
  @override
  Widget build(BuildContext context) {
    Widget homePage;
    if (kIsWeb) {
      homePage = WelcomePage();
    } else {
      homePage = WelcomePage();
    }

    return MaterialApp(
      title: 'Mon application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homePage,
    );
  }
}
