import 'package:app_geo/user/view/webView/Components/HelpPage.dart';
import 'package:app_geo/user/view/webView/Components/RecentConnexion.dart';
import 'package:app_geo/user/view/webView/Components/instructionFilter.dart';
import 'package:app_geo/user/view/webView/Components/webFilter.dart';
import 'package:app_geo/user/view/webView/adminView/adminView.dart';
import 'package:app_geo/user/view/webView/form/ForgotPwd/EmailForm.dart';
import 'package:app_geo/user/view/webView/form/addChild.dart';
import 'package:app_geo/user/view/webView/form/login.dart';
import 'package:app_geo/user/view/webView/form/signUp.dart';
import 'package:app_geo/user/view/webView/homePageWeb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'user/view/mobileView/homePage/HomePageMobile.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as Stripe;
import 'package:universal_platform/universal_platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool kIsWeb = UniversalPlatform.isWeb;

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCuynOOShyoFbZLzU9nZlnf0m2_vy1vkro",
            authDomain: "appversionfinal.firebaseapp.com",
            databaseURL:
                "https://app-geolocalisation-default-rtdb.firebaseio.com",
            projectId: "appversionfinal",
            storageBucket: "appversionfinal.appspot.com",
            messagingSenderId: "1004409327096",
            appId: "1:1004409327096:web:cf2f7f5211197cdc539a0d"));
  } else {
    await Firebase.initializeApp();
  }
  if (!kIsWeb) {
    Stripe.Stripe.publishableKey =
        "pk_test_51MyuqwGRwOwBwhmrw3km2Ot4mJEqksYb4Nfkojr0sWrUZE9Ra4dR8IBioGBJ4RIWKSh7a0JKkuuQXUCy576vTmCE00ZRhPKqM9";
  } else {
    //StripeApi.init(
    //"pk_test_51MyuqwGRwOwBwhmrw3km2Ot4mJEqksYb4Nfkojr0sWrUZE9Ra4dR8IBioGBJ4RIWKSh7a0JKkuuQXUCy576vTmCE00ZRhPKqM9");
  }
  runApp(ParentApp());
}

class ParentApp extends StatefulWidget {
  @override
  _ParentAppState createState() => _ParentAppState();
}

class _ParentAppState extends State<ParentApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    Widget homePage;
    if (kIsWeb) {
      homePage = HomePageWeb();
    } else {
      homePage = WelcomePage();
    }

    return MaterialApp(
      title: 'Mon application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => LoginWeb());
        }
        if (settings.name == '/SignUp') {
          return MaterialPageRoute(builder: (context) => SignUpWeb());
        }
        if (settings.name == '/RecentConnexion') {
          return MaterialPageRoute(builder: (context) => RecentConnnexionWeb());
        }
        if (settings.name == '/AddChild') {
          return MaterialPageRoute(builder: (context) => AddChildWeb());
        }
        if (settings.name == '/ForgotPwd') {
          return MaterialPageRoute(builder: (context) => ForgotPasswordWeb());
        }

        if (settings.name == '/help') {
          return MaterialPageRoute(builder: (context) => GettingHelpWeb());
        }
        if (settings.name == '/filter') {
          return MaterialPageRoute(builder: (context) => WebFilterWeb());
        }
        if (settings.name == '/instruction') {
          return MaterialPageRoute(builder: (context) => InstructionWeb());
        }
        if (settings.name == '/Admin') {
          return MaterialPageRoute(builder: (context) => Admin());
        }
      },
      home: homePage,
    );
  }
}
