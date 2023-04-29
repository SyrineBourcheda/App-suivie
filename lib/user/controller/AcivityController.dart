import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Activity.model.dart';

Future addActivity(Activity activity) async {
  final docUser = FirebaseFirestore.instance.collection("Activity").doc();
  activity.IdActivity = docUser.id;
  await docUser.set(activity.toJson());
}

Future updateActivity(String idActivity, String newPlaceName,
    String newStartTime, String newEndTime, String newPosition) async {
  await FirebaseFirestore.instance
      .collection('Activity')
      .doc(idActivity)
      .update({
    'PlaceName': newPlaceName,
    'StartTime': newStartTime,
    'EndTime': newEndTime,
    'Position': newPosition,
    'nb': 0,
    'NotifSended': false
  });
}
