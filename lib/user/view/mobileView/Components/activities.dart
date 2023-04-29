import 'package:app_geo/user/model/child.model.dart';
import 'package:app_geo/user/view/mobileView/Components/ChildTraker.dart';
import 'package:app_geo/user/view/mobileView/form/activity-form/activity-form.dart';
import 'package:app_geo/user/view/mobileView/form/activity-form/activity-update.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Activities extends StatefulWidget {
  final String? id;
  const Activities({Key? key, required this.id}) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  String? _idChild;
  @override
  void initState() {
    super.initState();
    _idChild = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#EFF7FA"),
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 80, left: 50),
              child: Text('TimeTable',
                  style: GoogleFonts.oleoScript(
                      fontSize: 25, fontStyle: FontStyle.italic)),
            ),

            Icon(Icons
                .date_range) // Remplacez cet icône par celui que vous souhaitez utiliser
          ],
        ),
        backgroundColor: HexColor("#87B1F8"),
        toolbarHeight: 70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print(_idChild);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChildTracker(childId: _idChild)),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Activity')
            .where("idEnfant", isEqualTo: _idChild)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final activities = snapshot.data!.docs;

            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Container(
                  padding: const EdgeInsets.only(top: 25, right: 30, left: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityUpdate(
                                idActivity: activity["IdActivity"])),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('#FFFFFF'),
                          //borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 15,
                              blurRadius: 17,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          /*
                        children: [
                          ListTile(
                            title: Text('${activity['PlaceName']}'),
                            subtitle: Text(
                              'Position: ${activity['Position']}',
                              style: const TextStyle(
                                  //color: Colors.black.withOpacity(0.6),
                                  ),
                            ),
                          ),
                        ],*/
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                          width: 0.2, color: Colors.grey),
                                    ),
                                  ),

                                  padding: EdgeInsets.only(right: 20),
                                  //margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(25, 20, 0, 5),
                                        child: Text(
                                          '${activity['StartTime'].split(" ")[1]}',
                                          style: GoogleFonts.oleoScript(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              color: HexColor("#000000")),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(25, 0, 0, 5),
                                        child: Text(
                                          '${activity['EndTime'].split(" ")[1]}',
                                          style: GoogleFonts.oleoScript(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              color: HexColor("#000000")),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 10),
                                        child: Text(
                                          '${activity['EndTime'].split(" ")[0]}',
                                          style: GoogleFonts.oleoScript(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              color: HexColor("#000000")),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 80, 12),
                                      child: Text(
                                        '${activity['PlaceName']}',
                                        style: GoogleFonts.oleoScript(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            color: HexColor("#000000")),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 80, 12),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: HexColor("#87B1F8")),
                                          SizedBox(width: 5),
                                          Text(
                                            '${activity['Position']}',
                                            style: GoogleFonts.oleoScript(
                                                fontSize: 15,
                                                fontStyle: FontStyle.italic,
                                                color: HexColor("#000000")),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ActivityAdd(idEnfant: _idChild)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: HexColor("#87B1F8"),
      ),
    );
  }
}
