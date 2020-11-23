import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddOrEditCommentWidgetStateProvider with ChangeNotifier {

  bool _isDisposed = false;

  AddOrEditCommentWidgetStateProvider() {
    this._focusNode = new FocusNode();
    this._textEditingController = new TextEditingController();
    print('state provider for the bottom widget to add or edit comments created');
  }



  TextEditingController _textEditingController;
  FocusNode _focusNode;

  TextEditingController get textController => _textEditingController;

  FocusNode get focusNode => _focusNode;

  void clearTextController() {
    if (textController.text.isNotEmpty) {
      textController.clear();
      setIsSendButtonVisibilityTo(false);
    }
  }

  void removeFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      notifyMyListeners();
    }
  }

  void resetWidget() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      notifyMyListeners();
    }
    if (textController.text.isNotEmpty) {
      textController.clear();
      setIsSendButtonVisibilityTo(false);
    }

    _isCommentUpadting = false;
    _isSendButtonVisible = false;
  }

  // =========================================================================
  // add or update a comment visibility controllers
  // regarding comment text field

  bool _isCommentUpadting = false;

  bool get isCommentUpdating => _isCommentUpadting;

  void setIsCommentUpdatingTo(bool update) {
    if (update != null) {
      _isCommentUpadting = update;
      notifyMyListeners();
    }
  }

  bool _isSendButtonVisible = false;

  bool get isSendButtonVisible => _isSendButtonVisible;

  void setIsSendButtonVisibilityTo(bool update) {
    if (update != null) {
      _isSendButtonVisible = update;
      notifyMyListeners();
    }
  }

  void notifyMyListeners(){
    if(!_isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('AddOrEdit comments state Provider has been disposed');
    super.dispose();
  }
}
