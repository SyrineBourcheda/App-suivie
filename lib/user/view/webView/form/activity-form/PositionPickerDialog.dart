import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class PositionPickerDialog extends StatefulWidget {
  @override
  _PositionPickerDialogState createState() => _PositionPickerDialogState();
}

class _PositionPickerDialogState extends State<PositionPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  MapController _mapController = MapController();
  LatLng? _selectedPosition;
  double _defaultZoom = 13.0;

  void _handleTap(LatLng point) {
    setState(() {
      _selectedPosition = point;
    });
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
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 18),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _searchLocation,
                icon: Icon(
                  Icons.search,
                  color: HexColor("#87B1F8"),
                ),
              ),
            ],
          ),
          Flexible(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(48.8566, 2.3522),
                zoom: _defaultZoom,
                onTap: (tapPosition, latLng) => _handleTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _selectedPosition != null
                      ? [
                          Marker(
                            point: _selectedPosition!,
                            builder: (ctx) => Icon(Icons.location_on),
                          ),
                        ]
                      : [],
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return HexColor("#87B1F0");
                  }
                  return HexColor("#87B1F8");
                },
              ),
            ),
            onPressed: _selectedPosition != null
                ? () {
                    Navigator.of(context).pop(_selectedPosition);
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Position',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(width: 5.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
