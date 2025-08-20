import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  String? uid;
  Timestamp? addedOn;
  int? lastMessageTime;
  int? unReadFromUser;

  ContactModel({this.uid, this.addedOn, this.lastMessageTime, this.unReadFromUser});

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      uid: json['uid'],
      lastMessageTime: json['lastMessageTime'],
      unReadFromUser: json['unReadFromUser'],
      addedOn: json['addedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (uid != null) data['uid'] = uid;
    if (addedOn != null) data['addedOn'] = addedOn;
    if (unReadFromUser != null) data['unReadFromUser'] = unReadFromUser;
    if (lastMessageTime != null) data['lastMessageTime'] = lastMessageTime;

    return data;
  }
}
