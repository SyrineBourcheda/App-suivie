import 'package:app_geo/user/controller/NotificationController.dart';
import 'package:app_geo/user/controller/user.controller.dart';
import 'package:app_geo/user/model/Notification.model.dart';
import 'package:app_geo/user/view/mobileView/Components/RecentConnexion.dart';
import 'package:app_geo/user/view/mobileView/Components/chatParent.dart';
import 'package:app_geo/user/view/mobileView/Components/recordChild.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../homePage/HomePageMobile.dart';
import 'HelpPage.dart';
import 'ParentAppList.dart';
import 'activities.dart';
import 'carte.dart';
import 'signOut.dart';
import 'webFilter.dart';

bool equal = false;
var activity;
String placeName = '';

class ChildTracker extends StatefulWidget {
  @override
  _ChildTrackerState createState() => _ChildTrackerState();
  final String? childId;
  ChildTracker({required this.childId});
}

class _ChildTrackerState extends State<ChildTracker> {
  PermissionStatus _storagePermissionStatus = PermissionStatus.denied;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    setState(() {
      _storagePermissionStatus = status;
    });
  }

  void _demarrerServeur() async {
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 3000);
    print('Serveur démarré sur le port ${server.port}');

    await for (final request in server) {
      if (request.uri.path == '/sos') {
        print("notif");
        _jouerSonSOS();
        print("son joué");
      }
    }
  }

  void _jouerSonSOS() async {
    final player = AudioPlayer();
    print("hello");
    await player.play(AssetSource('sounds/sos.mp3'));
  }

  String? childId;

  Future<String>? getPlaceName(double latitude, double longitude) async {
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      final Placemark placemark = placemarks.first;
      final place = placemark.name;
      return '$place';
    } else {
      throw Exception('Failed to get place name for $latitude, $longitude');
    }
  }

  void ComparerPosition(String? pos, double latitude, double longitude) async {
    String? p = await getPlaceName(latitude, longitude);
    if (pos == p) {
      print("les variable sont egale");
      equal = true;
    } else {
      equal = false;
    }
  }

  int CompareDate(String dateString1, String dateString2) {
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
    DateTime dateTime1 = format.parse(dateString1);
    DateTime dateTime2 = format.parse(dateString2);

    int comparisonResult = dateTime1.compareTo(dateTime2);
    return comparisonResult;
  }

  List<String> maListe = [];
//notif
  void GetNotification(String id) {
    FirebaseFirestore.instance
        .collection('Notification')
        .where('idEnfant', isEqualTo: "hhGQbfKaXGixZmseV5Xi")
        .orderBy('temps', descending: true)
        .snapshots()
        .listen((snapshot) {
      snapshot.docs.forEach((document) {
        maListe.add(document['ContenuNotif']);
        print(document['ContenuNotif']);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _requestStoragePermission();
    _demarrerServeur();

    childId = widget.childId;
    maListe.clear();
    GetNotification(childId!);
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String dropdownValue = list.first;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#87B1F8'),
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          'KidLocator',
          style: GoogleFonts.oleoScript(
            color: Colors.white,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.email),
              onPressed: () {
                if (maListe.isNotEmpty) {
                  List<PopupMenuEntry<String>> menuItems = [];
                  for (String item in maListe) {
                    menuItems.add(
                      PopupMenuItem(
                        child: Text(item),
                        value: item,
                      ),
                    );
                    if (menuItems.length <= maListe.length * 2 - 2) {
                      menuItems.add(const PopupMenuDivider());
                    }
                  }
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;
                  final RelativeRect position = RelativeRect.fromRect(
                    Rect.fromPoints(
                      button.localToGlobal(
                          button.size.topRight(Offset(0.0, 100.0)),
                          ancestor: overlay),
                      button.localToGlobal(
                          button.size.topRight(Offset(0.0, 100.0)),
                          ancestor: overlay),
                    ),
                    Offset.zero & overlay.size,
                  );
                  showMenu(
                    context: context,
                    position: position,
                    items: menuItems,
                  );
                }
              },
            ),
          ),
        ],
      ),
      drawer: _drawer(id: childId),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Childs')
            .doc(childId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          while (snapshot.data!.data() == null) {
            return Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          if (data['status'] == "connecté") {
            String LAT = data['lat'];
            String LNG = data['lng'];
            String name = data['Name'];
            String ParentId = data['ParentId'];
            double lat = double.parse(LAT);
            double lng = double.parse(LNG);
            String position = data['positionTime'];
            String image = data['image'];

            if (LAT == '' || LNG == '') {
              return Center(child: Text('No location data'));
            }
            while (position == '') {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: LatLng(lat, lng),
                    zoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(lat, lng),
                          width: 100,
                          height: 70,
                          builder: (context) {
                            return Stack(
                              children: [
                                Icon(Icons.location_pin),
                                Positioned(
                                  width: 30,
                                  height: 30,
                                  bottom: 30,
                                  left: 20,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(image),
                                    radius: 20,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Activity')
                      .where('idEnfant', isEqualTo: childId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    final activites = snapshot.data!.docs;
                    print(activites.length);
                    for (var activite in activites) {
                      print(activite['EndTime']);
                      String start = activite['StartTime'];
                      String end = activite['EndTime'];
                      int nb = 0;
                      print(position);
                      if (CompareDate(position, end) <= 0 &&
                          CompareDate(position, start) > 0) {
                        print('hello');
                        print(position);
                        activity = activite;
                        if (activity != null) {
                          if (activity["NotifSended"] == false &&
                              activity["nb"] == 0) {
                            activity["NotifSended"];
                            ComparerPosition(activity['Position'], lat, lng);
                            placeName = activity['PlaceName'];
                            String message = "$name has left $placeName";
                            if (!equal) {
                              final Notif = notifications(
                                  ContenuNotif: message,
                                  idParent: ParentId,
                                  idEnfant: childId,
                                  temps: Timestamp.now());
                              if (activity["NotifSended"] == false) {
                                addNotification(Notif);
                              }

                              FirebaseFirestore.instance
                                  .collection('Activity')
                                  .doc(activity['IdActivity'])
                                  .update({'NotifSended': true});
                              print(activity["NotifSended"]);
                            }
                          }
                        }

                        break;
                      }
                    }

                    return Container();
                  },
                ),
              ],
            );
          } else {
            return RecentConnnexion();
          }
        },
      ),
      bottomNavigationBar: SalomonBottomBar(
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xff6300ee),
          unselectedItemColor: const Color(0xff757575),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatParent(id: childId)));
            }
            if (index == 0) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Activities(id: childId)));
            }
            if (index == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EnfantApp(idEnfant: childId!)));
            }
          },
          items: _navBarItems),
    );
  }
}

final _navBarItems = [
  SalomonBottomBarItem(
    icon: const Icon(
      Icons.calendar_today,
      size: 30,
    ),
    title: const Text("Activity"),
    selectedColor: HexColor('#87B1F8'),
  ),
  SalomonBottomBarItem(
    icon: const Icon(
      Icons.chat,
      size: 30,
    ),
    title: const Text("Chat"),
    selectedColor: HexColor('#87B1F8'),
  ),
  SalomonBottomBarItem(
    icon: const Icon(
      Icons.mic,
      size: 30,
    ),
    title: const Text("Listener"),
    selectedColor: HexColor('#87B1F8'),
  ),
];

class _drawer extends StatelessWidget {
  final String? id;
  _drawer({required this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: HexColor('#EFF7FA'),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(padding: EdgeInsets.only(top: 50)),
            ListTile(
              leading: Icon(
                Icons.home,
                color: HexColor('#DFBAB1'),
              ),
              title: Text(
                'Home',
                style: GoogleFonts.oleoScript(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            ListTile(
              leading: Icon(
                Icons.list,
                color: HexColor('#DFBAB1'),
              ),
              title: Text(
                'Childs List',
                style: GoogleFonts.oleoScript(fontSize: 15),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecentConnnexion()),
                );
              },
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            ListTile(
              leading: Icon(
                Icons.filter_alt_outlined,
                color: HexColor('#DFBAB1'),
              ),
              title: Text('Web Filter',
                  style: GoogleFonts.oleoScript(fontSize: 15)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WebFilter()),
                );
              },
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            ListTile(
              leading: Icon(
                Icons.app_blocking,
                color: HexColor('#DFBAB1'),
              ),
              title:
                  Text('App List', style: GoogleFonts.oleoScript(fontSize: 15)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ParentAppList(
                            Id: id,
                          )),
                );
              },
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            ListTile(
              leading: Icon(
                Icons.help_center,
                color: HexColor('#DFBAB1'),
              ),
              title: Text('Help Page',
                  style: GoogleFonts.oleoScript(fontSize: 15)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GettingHelp()),
                );
              },
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: HexColor('#DFBAB1'),
              ),
              title:
                  Text('Log Out', style: GoogleFonts.oleoScript(fontSize: 15)),
              onTap: () {
                FirebaseFirestore.instance
                    .collection('Childs')
                    .doc(id)
                    .update({'status': 'not connected'});
                signOut();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => WelcomePage()));
              },
            ),
            Divider(
              color: Colors.black.withOpacity(.2),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
          ],
        ));
  }
}
