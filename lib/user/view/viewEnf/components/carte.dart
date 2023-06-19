import 'dart:async';
import 'package:app_geo/user/controller/app.controller.dart';
import 'package:app_geo/user/controller/user.controller.dart';
import 'package:app_geo/user/model/App.model.dart';
import 'package:app_geo/user/view/mobileView/Components/signOut.dart';
import 'package:app_geo/user/view/mobileView/homePage/HomePageMobile.dart';
import 'package:app_geo/user/view/viewEnf/components/chatEnfant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart';

class MapForm extends StatefulWidget {
  final String id;
  MapForm({required this.id});

  @override
  _MapFormState createState() => _MapFormState();
}

class _MapFormState extends State<MapForm> {
  late CollectionReference _childAppsRef;
  void _sendInstalledApps() async {
    // Vérifie si l'autorisation est accordée

    if (await Permission.storage.request().isGranted) {
      // Si l'autorisation est accordée, récupérer les applications installées

      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: false,
        onlyAppsWithLaunchIntent: true,
      );

      for (Application app in apps) {
        if (!await app.systemApp) {
          //Uint8List iconData = await DeviceApps.getApplicationIcon(app.packageName);

          final appData = App(
              appName: app.appName,
              packageName: app.packageName,
              versionName: app.versionName,
              idEnfant: _id,
              isBlocked: false);

          // envoyer les données de l'application à la base de données Firestore

          addApp(appData);
        }
      }
    } else {
      // Si l'autorisation n'est pas accordée, afficher une boîte de dialogue pour demander l'autorisation

      await Permission.storage.request();
    }
  }

  final _codeController = TextEditingController();
  bool _isPasswordVisible = false;
  Future<void> _logout() async {
    // final user = FirebaseAuth.instance.currentUser;

    final childSnapshot = await FirebaseFirestore.instance
        .collection('Childs')
        .where('Id', isEqualTo: _id)
        .get();
    print(childSnapshot.docs.first["Code"]);

    if (childSnapshot.docs.first.exists) {
      final code = childSnapshot.docs.first["Code"];

      if (int.parse(_codeController.text) == code) {
        await FirebaseAuth.instance.signOut();
        FirebaseFirestore.instance
            .collection('Childs')
            .doc(_id)
            .update({'status': 'not connected'});
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      } else {
        print("wrong password");
      }
    }
  }

  String? _id;

  LatLng? _selectedPosition;
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final double _defaultZoom = 13.0;
  Future<bool> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  Future<void> updateChildLocation(String? childId) async {
    bool isPermissionGranted = await checkPermission();
    if (isPermissionGranted) {
      final position = await Geolocator.getCurrentPosition();
      final lat = position.latitude;
      final lng = position.longitude;
      await FirebaseFirestore.instance
          .collection('Childs')
          .doc('childId')
          .update({'lat': lat.toString(), 'lng': lng.toString()});
      setState(() {
        _selectedPosition = LatLng(lat, lng);
        _mapController.move(_selectedPosition!, _defaultZoom);
      });
    }
  }

  void _handleTap(LatLng point) {
    setState(() {
      _selectedPosition = point;
    });
  }

  void _saveLocation() {
    if (_selectedPosition != null) {
      final String locationName = _locationNameController.text.trim();
      updateChildLocation(_id);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Unable to get current location.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  StreamSubscription<Position>? _positionStreamSubscription;

  Future<void> StreamPosition() async {
    DateTime _currentPositionTime;
    String dateString = '';
    bool isPermissionGranted = await checkPermission();
    if (isPermissionGranted) {
      _positionStreamSubscription =
          Geolocator.getPositionStream().listen((position) async {
        await FirebaseFirestore.instance.collection('Childs').doc(_id).update({
          'lat': position.latitude.toString(),
          'lng': position.longitude.toString(),
          'positionTime': dateString
        });
        setState(() {
          _selectedPosition = LatLng(position.latitude, position.longitude);
          _mapController.move(_selectedPosition!, 15);

          _currentPositionTime = DateTime.now();
          dateString =
              "${DateTime.parse(_currentPositionTime.toString()).year}-${DateTime.parse(_currentPositionTime.toString()).month}-${DateTime.parse(_currentPositionTime.toString()).day} ${DateTime.parse(_currentPositionTime.toString()).hour}:${DateTime.parse(_currentPositionTime.toString()).minute} ";
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _childAppsRef = FirebaseFirestore.instance.collection('App');

    _sendInstalledApps();
    _requestStoragePermission();
    updateChildLocation(_id);
    StreamPosition();

    /*FirebaseFirestore.instance
            .collection('App')
            .doc(app["id"])
            .update({'isBlocked': false});*/

    getBlockedAppStream().listen((app) {
      DeviceApps.openAppSettings(app['packageName']);
      FirebaseFirestore.instance
          .collection('App')
          .doc(app["id"])
          .update({'isBlocked': false});
    });
  }

  int _selectedIndex = 0;
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _storagePermissionStatus = status;
    });
  }

  void _jouerSonSOS() async {
    final url = 'http://192.168.1.156:3000/sos';
    await http.get(Uri.parse(url));
    final player = AudioPlayer();
    await player.play(AssetSource('sounds/sos.mp3'));
  }

  Stream<DocumentSnapshot> getBlockedAppStream() {
    return FirebaseFirestore.instance
        .collection('App')
        .where('isBlocked', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

// Utilisation :

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Childs')
                .where('Id', isEqualTo: _id)
                .where('status', isEqualTo: 'not connected')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return (Scaffold(
                  appBar: AppBar(
                    backgroundColor: HexColor('#87B1F8'),
                    toolbarHeight: 60,
                    centerTitle: true,
                    leading: Icon(Icons.account_circle_rounded),
                    leadingWidth: 150,
                    title: Text(
                      'KidLocator',
                      style: GoogleFonts.oleoScript(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Open shopping cart',
                          onPressed: () {
                            // Show menu when icon is clicked
                            final RenderBox button =
                                context.findRenderObject() as RenderBox;
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;

                            final RelativeRect position = RelativeRect.fromRect(
                              Rect.fromPoints(
                                button.localToGlobal(
                                  button.size.topRight(Offset(0.0, 100.0)),
                                  ancestor: overlay,
                                ),
                                button.localToGlobal(
                                  button.size.topRight(Offset(0.0, 100.0)),
                                  ancestor: overlay,
                                ),
                              ),
                              Offset.zero & overlay.size,
                            );

                            showMenu(
                                context: context,
                                position: position,
                                items: [
                                  PopupMenuItem(
                                      child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: HexColor("#F8F5E6")
                                            .withOpacity(0.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: HexColor('#FAD7D7')
                                                .withOpacity(.9),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Text(
                                      'to log out, enter the parental password',
                                      style: GoogleFonts.oleoScript(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  )),
                                  PopupMenuItem(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: HexColor("#F8F5E6")
                                              .withOpacity(0.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: HexColor('#FAD7D7')
                                                  .withOpacity(.9),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: TextFormField(
                                        controller: _codeController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '  Please enter some text';
                                          }

                                          return null;
                                        },
                                        obscureText: !_isPasswordVisible,
                                        decoration: InputDecoration(
                                          labelText: 'Code',
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          hintText: 'Enter a Code',
                                          prefixIcon: const Icon(Icons.lock,
                                              color: Colors.black),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
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
                                        cursorColor: const Color.fromARGB(
                                                255, 67, 67, 67)
                                            .withOpacity(1),
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 30, left: 20, bottom: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _logout();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  HexColor("#F8F5E6")
                                                      .withOpacity(.8),
                                              foregroundColor: HexColor('#000'),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Text(
                                              'Confirm',
                                              style: GoogleFonts.oleoScript(
                                                color: HexColor('#000'),
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 30, left: 20, bottom: 10),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  HexColor("#F8F5E6")
                                                      .withOpacity(.8),
                                              foregroundColor: HexColor('#000'),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: GoogleFonts.oleoScript(
                                                color: HexColor('#000'),
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          },
                        ),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      Flexible(
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            center: LatLng(0, 0),
                            zoom: _defaultZoom,
                            onTap: (tapPosition, latLng) => _handleTap(latLng),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            if (_selectedPosition != null)
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _selectedPosition!,
                                    builder: (context) =>
                                        const Icon(Icons.location_on),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: SalomonBottomBar(
                      currentIndex: _selectedIndex,
                      onTap: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                        if (index == 0) {
                          _jouerSonSOS();
                        }
                        if (index == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatEnfant(childId: _id)));
                        }
                      },
                      items: [
                        SalomonBottomBarItem(
                          icon: const Icon(
                            Icons.sos,
                            size: 30,
                            color: Colors.red,
                          ),
                          title: const Text("Emergency call"),
                          selectedColor: Colors.red,
                        ),
                        SalomonBottomBarItem(
                          icon: const Icon(
                            Icons.chat,
                            size: 30,
                          ),
                          title: const Text("Chat"),
                          selectedColor: HexColor('#87B1F8'),
                        ),
                      ]),
                ));
              } else {
                return WelcomePage();
              }
            }));
  }

  Widget _gap() => const SizedBox(height: 16);
}
