import 'package:flutter/cupertino.dart';

import '../../../../../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../quiz_entity.dart';

class EditQuizItemStateProvider with ChangeNotifier {
  // errors messages
  String _questionErrorMessage;
  String _optionAerrorMessage;
  String _optionBerrorMessage;
  String _optionCerrorMessage;
  String _optionDrrorMessage;



  String get questionErrorMessage => _questionErrorMessage;

  String get optionAerrorMessage => _optionAerrorMessage;

  String get optionBerrorMessage => _optionBerrorMessage;

  String get optionCerrorMessage => _optionCerrorMessage;

  String get optionDrrorMessage => _optionDrrorMessage;

  // void setQuestionErrorMessageTo(String update) {
  //   if (_questionErrorMessage != update) {
  //     _questionErrorMessage = update;
  //     notifyMyListeners();
  //   }
  // }
  //
  // void setOptionAerrorMessageTo(String update) {
  //   if (_optionAerrorMessage != update) {
  //     _optionAerrorMessage = update;
  //     notifyMyListeners();
  //   }
  // }
  //
  // void setOptionBerrorMessageTo(String update) {
  //   if (_optionBerrorMessage != update) {
  //     _optionBerrorMessage = update;
  //     notifyMyListeners();
  //   }
  // }
  //
  // void setOptionCerrorMessageTo(String update) {
  //   if (_optionCerrorMessage != update) {
  //     _optionCerrorMessage = update;
  //     notifyMyListeners();
  //   }
  // }
  //
  // void setOptionDerrorMessageTo(String update) {
  //   if (_optionDrrorMessage != update) {
  //     _optionDrrorMessage = update;
  //     notifyMyListeners();
  //   }
  // }


  void setErrorMessageToNull(int pos){
    if(_errorMessages[pos] != null){
      _errorMessages[pos] = null;
      notifyMyListeners();
    }
  }

  List<String> _errorMessages;
  List<String> get errorMessages => _errorMessages;

  // form key
  GlobalKey<FormState> _formKey;
  TextEditingController _questionController;
  TextEditingController _optionAcontroller;
  TextEditingController _optionBcontroller;
  TextEditingController _optionCcontroller;
  TextEditingController _optionDcontroller;
  TextEditingController _explainController;

  TextEditingController get optionAcontroller => _optionAcontroller;

  TextEditingController get optionBcontroller => _optionBcontroller;

  TextEditingController get optionCcontroller => _optionCcontroller;

  TextEditingController get optionDcontroller => _optionDcontroller;

  TextEditingController get questionController => _questionController;

  TextEditingController get explainController => _explainController;

  GlobalKey<FormState> get formKey => _formKey;

  List<TextEditingController> _controllers;

  EditQuizItemStateProvider(QuizEntity quizEntity) {
    _formKey = new GlobalKey<FormState>();
    _questionController = new TextEditingController()..text = quizEntity.question;
    _optionAcontroller = new TextEditingController()..text = quizEntity.options[0];
    _optionBcontroller = new TextEditingController()..text = quizEntity.options[1];
    _optionCcontroller = new TextEditingController()..text = quizEntity.options[2];
    _optionDcontroller = new TextEditingController()..text = quizEntity.options[3];
    _explainController = new TextEditingController()..text = quizEntity.explain ?? '';

    _controllers = [
      _questionController,
      _optionAcontroller,
      _optionBcontroller,
      _optionCcontroller,
      _optionDcontroller,
    ];
    _answers = parseAnswers(quizEntity.answers);

    // _errorMessageSetters = [
    //   setQuestionErrorMessageTo,
    //   setOptionAerrorMessageTo,
    //   setOptionBerrorMessageTo,
    //   setOptionCerrorMessageTo,
    //   setOptionDerrorMessageTo,
    // ];

    _errorMessages = [
      _questionErrorMessage,
      _optionAerrorMessage,
      _optionBerrorMessage,
      _optionCerrorMessage,
      _optionDrrorMessage,
    ];
  }

  List<bool> _answers = [false, false, false, false];

  List<bool> get answers => _answers;

  void updateAnswers(bool update, int pos) {
    answers[pos] = update;
    notifyMyListeners();
  }

  // bool _ensureFieldsAreNotNull() => _question != null && _answers != null && _options != null;

  bool validateAnswers() => _answers.any((element) => element);

  bool validateFields() {
    for (var i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        _errorMessages[i] = 'this field is required';
      }
    }
    return _errorMessages.every((message) => message == null);
  }

  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  void saveAndUpload() {
    if (validateFields()) {
      print('all fields are valid');
      if (!validateAnswers()) {
        print('inside first condition');

        locator<DialogService>().showDialogOfFailure(message: 'you must choose at least one correct answer');
      } else {
        print('inside else condition');
        Map<String, dynamic> payload = {
          'question': _questionController.text,
          'options': [optionAcontroller.text, optionBcontroller.text, optionCcontroller.text, optionDcontroller.text],
          'answers': _answers.asMap().entries.where((element) => element.value).map((e) => e.key).toList(),
          'explain': _explainController.text.isEmpty ? null : _explainController.text
        };
        print(payload);
      }
    } else {
      print('all or some fields are not valid');
      print(_errorMessages);
      notifyMyListeners();
    }
  }

  List<bool> parseAnswers(List<int> update) {
    final List<bool> rawList = new List<bool>.filled(4, false, growable: false);
    for (int i in update) {
      rawList[i] = true;
    }
    return rawList;
  }

  @override
  void dispose() {
    _isDisposed = true;
    _optionAcontroller.dispose();
    _optionBcontroller.dispose();
    _optionCcontroller.dispose();
    _optionDcontroller.dispose();
    print('edit quiz item state provider has been disposed');
    super.dispose();
  }
}
