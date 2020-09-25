
import 'package:flutter/cupertino.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/message_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/sender_model.dart';
import 'package:sembast/sembast.dart';

import '../app_database.dart';

class MessageAccessObject{
  // database instance getter
  Future<Database> get database async => await LocalDatabase.getInstance().database;
  List<String> senderIds;

  static const String _SENDER_STORES = 'senders';
  var senders = intMapStoreFactory.store(_SENDER_STORES);

  // fetch all senders with their last messages
  Future<List<MessageSender>> fetchSenders()async{
   var records = await senders.find(await this.database);
    List<MessageSender> result = records.map((record) => new MessageSender.fromHashMap(record.value));
    if(result == null || result.length == 0){
      return <MessageSender>[];
    }
    return result;
  }

  // fetch messages of specific sender
  Future<List<MessageItem>> fetchMessagesOfSender({@required String senderId })async{
    var store = intMapStoreFactory.store(senderId);
    var records = await store.find(await this.database,finder: Finder(
    ));
    List<MessageItem> messages = records.map((record) => new MessageItem.fromHashMap(record.value));
    return messages;
  }

  // save message from an old sender
  Future<bool> saveMessage({MessageItem message})async{
      var store = intMapStoreFactory.store(message.senderID);
      try{
        await store.add(await this.database, message.asHashMap());
        return true;
      }catch(err){
        return false;
      }
  }


  // save a message from a new sender
  Future<bool> saveMessageForNewSender({@required MessageItem message,MessageSender messageSender})async{
      await senders.add(await this.database, messageSender.asHashMap());
      return await saveMessage(message: message);
  }

  Future<bool> updateLastMessage(MessageItem messageItem)async{

  }

}