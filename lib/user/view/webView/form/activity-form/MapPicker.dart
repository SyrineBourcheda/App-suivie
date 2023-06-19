import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/src/datetime_picker_theme.dart'
    as datePicker;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class MapPicker extends StatefulWidget {
  final MapController mapController;

  const MapPicker({required this.mapController});

  @override
  _MapPickerState createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  LatLng? selectedLocation;

  void _onLocationSelected(LatLng location) {
    setState(() {
      selectedLocation = location;
      widget.mapController.move(location, 15.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.mapController,
          options: MapOptions(
            center: LatLng(37.7749, -122.4194),
            zoom: 13.0,
            onTap: (tapPosition, latLng) => _onLocationSelected(latLng),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: selectedLocation != null
                  ? [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: selectedLocation!,
                        builder: (ctx) => Icon(Icons.location_on),
                      ),
                    ]
                  : [],
            ),
          ],
        ),
        Positioned(
          bottom: 20.0,
          left: 20.0,
          right: 20.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, 2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                selectedLocation != null
                    ? 'Location: ${selectedLocation!.latitude.toStringAsFixed(4)}, ${selectedLocation!.longitude.toStringAsFixed(4)}'
                    : 'Tap the map to select a location',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
