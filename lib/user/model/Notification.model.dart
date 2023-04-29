import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';


class notifications{
  String idNotif ;
  String ContenuNotif;
  String idParent;
  String? idEnfant;
  notifications({this.idNotif='',required this.ContenuNotif,required this.idEnfant,required this.idParent});


  Map<String,dynamic> toJson(){
  return{
    'idNotif':idNotif,
    'ContenuNotif':ContenuNotif,
    'idParent':idParent,
    'idEnfant':idEnfant,
    
  };

}

factory notifications.fromJson(Map<String,dynamic>json){
  return notifications(idNotif:json['idNotif'],ContenuNotif: json['ContenuNotif'],
  idParent: json['idParent'],idEnfant: json['idEnfant']);
}
}