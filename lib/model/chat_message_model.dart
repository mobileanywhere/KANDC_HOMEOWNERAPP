import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String? uid;
  String? senderId;
  String? receiverId;
  String? photoUrl;
  String? messageType;
  bool? isMe;
  bool? isMessageRead;
  String? message;
  int? createdAt;
  Timestamp? createdAtTime;
  Timestamp? updatedAtTime;
  DocumentReference? chatDocumentReference;

  ChatMessageModel({
    this.uid,
    this.senderId,
    this.createdAtTime,
    this.updatedAtTime,
    this.receiverId,
    this.createdAt,
    this.message,
    this.isMessageRead,
    this.photoUrl,
    this.messageType,
    this.chatDocumentReference,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      uid: json['uid'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      isMessageRead: json['isMessageRead'],
      photoUrl: json['photoUrl'],
      messageType: json['messageType'],
      createdAt: json['createdAt'],
      createdAtTime: json['createdAtTime'],
      updatedAtTime: json['updatedAtTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (uid != null) data['uid'] = uid;
    if (createdAt != null) data['createdAt'] = createdAt;
    if (message != null) data['message'] = message;
    if (senderId != null) data['senderId'] = senderId;
    if (isMessageRead != null) data['isMessageRead'] = isMessageRead;
    if (receiverId != null) data['receiverId'] = receiverId;
    if (photoUrl != null) data['photoUrl'] = photoUrl;
    if (createdAtTime != null) data['createdAtTime'] = createdAtTime;
    if (updatedAtTime != null) data['updatedAtTime'] = updatedAtTime;
    if (messageType != null) data['messageType'] = messageType;
    return data;
  }
}
