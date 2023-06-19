import 'package:app_geo/user/view/mobileView/Components/chatParent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MapForm extends StatefulWidget {
  const MapForm({Key? key}) : super(key: key);

  @override
  _MapFormState createState() => _MapFormState();
}

class _MapFormState extends State<MapForm> {
  LatLng? _selectedPosition;
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final double _defaultZoom = 13.0;

  void _handleTap(LatLng point) {
    setState(() {
      _selectedPosition = point;
    });
  }

  void _saveLocation() {
    if (_selectedPosition != null) {
      final String locationName = _locationNameController.text.trim();
      // Do something with the location name and selected position
    }
  }

  void _searchLocation() async {
    final String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(searchText);
        if (locations.isNotEmpty) {
          _mapController.move(
            LatLng(locations.first.latitude, locations.first.longitude),
            _defaultZoom,
          );
          setState(() {
            _selectedPosition =
                LatLng(locations.first.latitude, locations.first.longitude);
          });
        }
      } catch (e) {
        // Handle error
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(45.5231, -122.6765),
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
                        builder: (context) => const Icon(Icons.location_on),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      ),
    );
  }
}

Widget _drawer() => Drawer(
    backgroundColor: HexColor('#EFF7FA'),
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
            //Navigator.pop(context);
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
          title:
              Text('Web Filter', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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
              Text('App Blocking', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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
          title: Text('Help Page', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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
          title: Text('Log Out', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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

const List<String> list = <String>[
  'OneOneOneOneOneOneOneOneOneOneOneOneOne',
  'Two',
  'Three',
  'Four',
  'Three',
  'Three',
  'Three',
  'Three',
  'Three'
];
/**
 * class MapForm extends StatefulWidget {
  const MapForm({Key? key}) : super(key: key);

  @override
  _MapFormState createState() => _MapFormState();
}

class _MapFormState extends State<MapForm> {
  LatLng? _selectedPosition;
  final TextEditingController _locationNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final double _defaultZoom = 13.0;

  void _handleTap(LatLng point) {
    setState(() {
      _selectedPosition = point;
    });
  }

  void _saveLocation() {
    if (_selectedPosition != null) {
      final String locationName = _locationNameController.text.trim();
      // Do something with the location name and selected position
    }
  }

  void _searchLocation() async {
    final String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(searchText);
        if (locations.isNotEmpty) {
          _mapController.move(
            LatLng(locations.first.latitude, locations.first.longitude),
            _defaultZoom,
          );
          setState(() {
            _selectedPosition =
                LatLng(locations.first.latitude, locations.first.longitude);
          });
        }
      } catch (e) {
        // Handle error
        print(e.toString());
      }
    }
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    String dropdownValue = list.first;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#87B1F8'),
        toolbarHeight: 60,
         title: Container(
          padding:const EdgeInsets.only(left: 70),
          child: const Text('App Name'),
        ),
        actions: [
          Container(
            child: DropdownButton<String>(
            dropdownColor: HexColor('#FFFFF').withOpacity(0.9),
            menuMaxHeight: 400,
            padding: EdgeInsets.only(right: 25),
            icon: const Icon(Icons.email, color: Colors.white),
            elevation: 16,
            style: const TextStyle(color: Colors.pink),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                dropdownValue = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          )
        ],
        
      
      ),
      
      
      drawer: _drawer(),
      body: Column(
        children: [
          Flexible(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(45.5231, -122.6765),
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
                        builder: (context) => const Icon(Icons.location_on),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ChatParent()));
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
  SalomonBottomBarItem(
    icon: const Icon(
      Icons.photo,
      size: 30,
    ),
    title: const Text("Photo"),
    selectedColor: HexColor('#87B1F8'),
  ),
];

Widget _drawer() => Drawer(
    backgroundColor: HexColor('#EFF7FA'),
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
            //Navigator.pop(context);
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
          title:
              Text('Web Filter', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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
              Text('App Blocking', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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
          title: Text('Help Page', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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
          title: Text('Log Out', style: GoogleFonts.oleoScript(fontSize: 15)),
          onTap: () {
            //Navigator.pop(context);
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

const List<String> list = <String>[
  'OneOneOneOneOneOneOneOneOneOneOneOneOne',
  'Two',
  'Three',
  'Four',
  'Three',
  'Three',
  'Three',
  'Three',
  'Three'
];
 */