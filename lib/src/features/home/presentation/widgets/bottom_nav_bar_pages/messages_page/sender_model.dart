import 'package:flutter/foundation.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MessageSender {
  String name, image, id, oneSignalID;
  LastMessage lastMessage;
  int newMessages = 0;

  MessageSender({
    @required this.id,
    @required this.oneSignalID,
    @required this.name,
    @required this.image,
    @required this.lastMessage,
  });

  Map<String, String> asHashMap() => {
        'id': this.id,
        'oneSignalID': this.oneSignalID,
        'name': this.name,
        'image': this.image,
        'lastMessage': this.lastMessage.asHashMap().toString(),
      };

  MessageSender.fromHashMap(Map<String, dynamic> hashMap)
      : this.id = hashMap['id'],
        this.name = hashMap['name'],
        this.image = hashMap['image'],
        this.lastMessage = hashMap['lastMessage'],
        this.oneSignalID = hashMap['oneSignalID'];
}

class LastMessage {
  String content;
  bool fromMe;
  DateTime iat;

  LastMessage({
    @required this.fromMe,
    @required this.content,
    @required this.iat,
  });

  Map<String, String> asHashMap() => {
        'fromMe': this.fromMe.toString(),
        'content': this.content,
        'iat': this.iat.toString(),
      };
}
