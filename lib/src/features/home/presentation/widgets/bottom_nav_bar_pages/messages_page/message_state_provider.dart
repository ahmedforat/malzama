import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/messages_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/global_current_sender.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/messages_page/sender_model.dart';

import 'message_model.dart';

class MessagesStateProvider with ChangeNotifier {

  // current sender (if the user is already chatting with someone
  CurrentSender currentSender = locator.get<CurrentSender>();

  // local Database client
  MessageAccessObject messageAccessObject;

  // constructor
  MessagesStateProvider() {
    messageAccessObject = new MessageAccessObject();
    updateSenders();
  }

  // senders of messages
  List<MessageSender> _sendersList = <MessageSender>[];

  // list of messages of the current sender // i.e the sender that the chat page is already opened
  List<MessageItem> _messagesOfCurrentSender;

  // getter of the senders
  List<MessageSender> get sendersList => _sendersList;

  // getter of the messages of the current sender //  i.e the sender that the chat page is already opened
  List<MessageItem> get messagesOfCurrentSender => _messagesOfCurrentSender;

  int _notOpenedMessages = 0;

  // fetch all the senders from the local database
  Future<void> updateSenders() async {
    _sendersList = await messageAccessObject.fetchSenders();
    notifyListeners();
  }

  // update last message for specific sender
  void _updateLastMessage(MessageItem messageItem) {
    for (MessageSender sender in _sendersList) {
      if (sender.id == messageItem.senderID) {
        sender.lastMessage.fromMe = messageItem.senderID == null;
        sender.lastMessage.content = messageItem.content;
      }
    }
  }


  // fetch messages of the current sender
  Future<void> fetchMessagesOfSenderByID({String id})async{
    _messagesOfCurrentSender = await messageAccessObject.fetchMessagesOfSender(senderId: id);
    notifyListeners();
  }

  // nullify messages of current sender whom the chat was with
  void setMessagesListToZero(){
    _messagesOfCurrentSender = [];
    notifyListeners();
  }

  // add a new message to the messages list
  void appendToMessages(MessageItem messageItem) async {
    // check whether the sender is already exist or not
    MessageSender alreadyExistSender = _sendersList.firstWhere((sender) => sender.id == messageItem.senderID,orElse: () => null);
    if (alreadyExistSender != null) {
      await messageAccessObject.saveMessage(message: messageItem);
      _updateLastMessage(messageItem);
      if(!messageItem.fromMe && !currentSender.check(messageItem.senderID)){
        for(MessageSender sender in _sendersList){
          if(sender.id == messageItem.senderID){
            sender.newMessages++;
            notifyListeners();
            break;
          }
        }
      }

    } else {
      MessageSender messageSender = new MessageSender(
          id: messageItem.senderID,
          oneSignalID: messageItem.senderOneSignalID,
          name: messageItem.sender,
          image: messageItem.senderImage,
          lastMessage: new LastMessage(fromMe: messageItem.senderID == null, content: messageItem.content,iat: DateTime.now()),
          );

      // update the count of new messages if the chat is not opened with this sender
        if(!currentSender.check(messageSender.id)){
          messageSender.newMessages++;
        }
        _sendersList.add(messageSender);

      // save message for a new sender
      await messageAccessObject.saveMessageForNewSender(
        message: messageItem,
        messageSender: messageSender,
      );
    }
    notifyListeners();
  }
}
