import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String idMessage;
  String texteMessage;
  String idParent;
  String idEnfant;
  String sender;
  FieldValue tempsEnvoi;
  bool isSeen;
  bool showTime;

  Message(
      {this.idMessage = '',
      required this.texteMessage,
      required this.idParent,
      required this.idEnfant,
      this.sender = '',
      required this.tempsEnvoi,
      this.isSeen = false,
      this.showTime = false});
  Map<String, dynamic> toJson() {
    return {
      'idMessage': idMessage,
      'texteMessage': texteMessage,
      'idParent': idParent,
      'idEnfant': idEnfant,
      'sender': sender,
      'tempsEnvoi': tempsEnvoi,
      'isSeen': isSeen,
      'showTime': showTime
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        idMessage: json['idMessage'],
        texteMessage: json['texteMessage'],
        idParent: json['idParent'],
        idEnfant: json['idEnfant'],
        sender: json['sender'],
        tempsEnvoi: json['tempsEnvoi'],
        isSeen: json['isSeen'],
        showTime: json['showTime']);
  }
}
