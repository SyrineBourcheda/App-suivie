import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
bool equal=false;
class PositionName extends StatelessWidget {
  
    const PositionName({Key? key}) : super(key: key);
    
    
Future<String>? getPlaceName(double latitude, double longitude) async {
  final List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  
  if (placemarks.isNotEmpty) {
    final Placemark placemark = placemarks.first;
    final city = placemark.locality ?? placemark.subLocality ?? placemark.administrativeArea;
    final state = placemark.administrativeArea ?? placemark.subAdministrativeArea;
    final country = placemark.country;
    final place=placemark.name;
    return '$place';
  } else {
    throw Exception('Failed to get place name for $latitude, $longitude');
  }
}


void ComparerPosition(String? pos, double latitude, double longitude)async{
  String? p=await getPlaceName(latitude, longitude);
if(pos==p){
  print("les variable sont egale");
  equal=true;
}else{print("diffrent");}
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Childs').doc('j9BNrwXDhOhQr1NaRzLs').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final lat = snapshot.data!['lat'];
        final lng = snapshot.data!['lng'];
        final position = snapshot.data!['positionTime'];
        String timeString = position.split(" ")[1];
        print(timeString);
        String dateString = position.split(" ")[0];
        Future <String>? pos= getPlaceName(double.parse(lat),double.parse(lng));

        return Column(
          children: [
            Text('Latitude: ${lat}'),
            Text('Longitude: ${lng}'),
            FutureBuilder<String>(
              future: getPlaceName(36.8121865, 10.0780806),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('Place name: ${snapshot.data}');
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Activity').where('idEnfant', isEqualTo: 'j9BNrwXDhOhQr1NaRzLs').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final activites = snapshot.data!.docs;
                //print(activites.length);
                // Votre code pour traiter les changements dans la collection "activites"
                var activity;
                for (var activite in activites) {
                 String start= activite['StartTime'].split(" ")[1];
                 String end= activite['EndTime'].split(" ")[1];
                 
                  if(int.parse(timeString.split(":")[0]) <int.parse(end.split(":")[0]) && int.parse(timeString.split(":")[0])>=int.parse(start.split(":")[0])){
                     
                     activity=activite;
                     break;
                  }
                  

                }
                if(activity !=null){
                  ComparerPosition(activity['Position'], double.parse(lat), double.parse(lng));
                  print(equal);
                }

               // print('Changement dans la collection "activites" : ${activites}');
                
                // Votre code pour mettre à jour le Stream de la collection "Childs"
                return Container();
              },
            ),
          ],
        );
      },
    ),
  );
}
}
