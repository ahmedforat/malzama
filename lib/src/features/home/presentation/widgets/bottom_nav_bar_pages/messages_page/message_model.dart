import 'package:flutter/foundation.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MessageItem {
  String content, sender, senderImage, senderID, senderOneSignalID;
  DateTime iat;
  bool isSent;
  bool isSeen;
  bool fromMe;

  MessageItem({
    @required this.content,
    @required this.sender,
    @required this.senderImage,
    @required this.iat,
    @required this.senderID, // user id from mongodb database
    @required this.senderOneSignalID,
    @required this.fromMe, // this is the player ID
    this.isSeen,
    this.isSent,
  });

  MessageItem.fromHashMap(Map<String, dynamic> hashMap)
      : this.content = hashMap['content'],
        this.sender = hashMap['sender'],
        this.senderImage = hashMap['senderImage'],
        this.iat = hashMap['iat'],
        this.senderID = hashMap['senderID'],
        this.fromMe = hashMap['fromMe'],
        this.isSeen = hashMap['isSeen'],
        this.isSent = hashMap['isSent'];

  Map<String, String> asHashMap() => {
        'content': this.content,
        'sender': this.sender,
        'senderImage': this.senderImage,
        'senderId': this.senderID,
        'iat': this.iat.toString(),
        'fromMe': this.fromMe.toString(),
        'isSeen': this.isSeen.toString(),
        'isSent': this.isSent.toString(),
      };
}
