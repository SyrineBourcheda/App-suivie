/*import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedPosition = LatLng(0, 0);
  String _selectedPlaceName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(48.858093, 2.294694),
          zoom: 13.0,
          onTap: (point) async {
            List<Placemark> placemarks = await placemarkFromCoordinates(
                point.latitude, point.longitude);
            if (placemarks != null && placemarks.isNotEmpty) {
              setState(() {
                _selectedPosition = point;
                _selectedPlaceName = placemarks[0].name;
              });
            }
          },
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c']),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _selectedPosition,
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Selected Place Name: $_selectedPlaceName',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
*/