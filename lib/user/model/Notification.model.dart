import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class notifications {
  String idNotif;
  String ContenuNotif;
  String idParent;
  String? idEnfant;
  Timestamp temps;

  notifications(
      {this.idNotif = '',
      required this.ContenuNotif,
      required this.idEnfant,
      required this.idParent,
      required this.temps});

  Map<String, dynamic> toJson() {
    return {
      'idNotif': idNotif,
      'ContenuNotif': ContenuNotif,
      'idParent': idParent,
      'idEnfant': idEnfant,
      'temps': temps
    };
  }

  factory notifications.fromJson(Map<String, dynamic> json) {
    return notifications(
      idNotif: json['idNotif'],
      ContenuNotif: json['ContenuNotif'],
      idParent: json['idParent'],
      idEnfant: json['idEnfant'],
      temps: json['temps'],
    );
  }
}
