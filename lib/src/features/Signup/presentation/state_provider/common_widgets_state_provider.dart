import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:malzama/src/core/platform/services/notifications_service/one_signal_notfication.dart';
import 'package:malzama/src/core/validators/signup_login_validators.dart';


import '../../../../core/references/references.dart';

class CommonWidgetsStateProvider with ChangeNotifier {

  bool _hidePassowrd = true;
  bool get hidePassword => _hidePassowrd;

  void switchPasswordVisibility(){
    _hidePassowrd = !_hidePassowrd;
    notifyMyListeners();
  }
  //List<String> _errorMessages = List.filled(7, fill);

   List<String> _errorMessages;

  List<String> get errorMessages => _errorMessages;
  List<TextEditingController> _textControllers;

  List<TextEditingController> get textControllers => _textControllers;


  bool validate(){
    _errorMessages[0] = FieldsValidators.validateFirstAndLastName(firstName: _textControllers[0].text);
    _errorMessages[1] = FieldsValidators.validateFirstAndLastName(firstName: _textControllers[1].text);
    _errorMessages[2] = FieldsValidators.validateEmail(mail: _textControllers[2].text);
    _errorMessages[3] = FieldsValidators.validatePassword(password: _textControllers[3].text);
    _errorMessages[4] = _checkPasswordMatching();


    _errorMessages[5] = _province == null || _province.isEmpty
        ? 'هذا الحقل مطلوب' : null;

    _errorMessages[6] = _gender == null || _gender.isEmpty
    ? 'هذا الحقل مطلوب' : null;



    notifyMyListeners();
    return !_errorMessages.any((message) => message != null);
  }

  void onChanged(int pos) {
    if (_errorMessages[pos] != null) {
      _errorMessages[pos] = null;
      notifyMyListeners();
    }
  }

  FocusNode _firstNameNode;
  FocusNode _lastNameNode;
  FocusNode _emailNode;
  FocusNode _passwordNode;
  FocusNode _confirmPasswordNode;

  FocusNode get firstNameNode => _firstNameNode;

  FocusNode get lastNameNode => _lastNameNode;

  FocusNode get emailNode => _emailNode;

  FocusNode get passwordNode => _passwordNode;

  FocusNode get confirmPasswordNode => _confirmPasswordNode;

  List<FocusNode> get _listOfAllNodes => [
        _firstNameNode,
        _lastNameNode,
        _emailNode,
        _passwordNode,
        _confirmPasswordNode,
      ];

  List<FocusNode> otherFocusNodesFor(FocusNode focusNode){
    return _listOfAllNodes.where((node) => node != focusNode).toList();
  }

  void fillTheFields() {
    _firstName = 'Karrar';
    _lastName = 'Mohammed';
    _email = 'k.mohammed1133@gmail.com';
    _password = '07718239773';
    notifyMyListeners();
  }

  void clearTheFields() {
    _firstName = null;
    _lastName = null;
    _email = null;
    _password = null;
    notifyMyListeners();
  }

  CommonWidgetsStateProvider() {
    _firstNameNode = new FocusNode();
    _lastNameNode = new FocusNode();
    _emailNode = new FocusNode();
    _passwordNode = new FocusNode();
    _confirmPasswordNode = new FocusNode();

    _textControllers = List.generate(5, (i) => new TextEditingController());
    _errorMessages = List.generate(7, (index) => null);
    NotificationService notificationService = NotificationService.getInstance();
    notificationService.initialize();
  }

  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();

    for (TextEditingController controller in _textControllers) {
      controller.dispose();
    }
    print('Common State has been disposed');
    super.dispose();
  }

  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _confirmPassword;
  String _passwordMatchingMessage;
  String _province;
  String _gender;
  String _university;
  String _college;
  String _section;
  String _stage;
  String _speciality;
  AccountType _accountType;
  List<String> _allCountries;

  List<String> get allCountries => _allCountries;

  String get stage => _stage;

  String get university => _university;

  String get college => _college;

  String get section => _section;

  AccountType get accountType => _accountType;

  void setAccountTypeTo(AccountType type) => _accountType = type;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get email => _email;

  String get password => _password;

  String get confirmPassword => _confirmPassword;

  String get passwordMatchingMessage => _passwordMatchingMessage;

  String get province => _province;

  String get gender => _gender;

  String get speciality => _speciality;

  void updateSpeciality({String update}) {
    if (_speciality != update) {
      _speciality = update;
      notifyMyListeners();
    }
  }

  void updateStage({String update}) {
    if (_stage != update) {
      _stage = update;
      notifyMyListeners();
    }
  }

  void updateUniversity({String update}) {
    if (_university != update) {
      _university = update;
      notifyMyListeners();
    }
  }

  void updateCollege({String update}) {
    if (_college != update) {
      _college = update;
      notifyMyListeners();
    }
  }

  void updateSection({String update}) {
    if (_section != update) {
      _section = update;
      notifyMyListeners();
    }
  }

  void updateFirstName({String update}) {
    _firstName = update;
    notifyMyListeners();
  }

  void updateLastName({String update}) {
    _lastName = update;
    notifyMyListeners();
  }

  void updateEmail({String update}) {
    _email = update;
    notifyMyListeners();
  }

  void updatePassword({String update}) {
    _password = update;
    if (_confirmPassword == null || _confirmPassword.isEmpty) {
      print('We are not doing anything');
      notifyMyListeners();
    } else {
      _checkPasswordMatching();
    }
  }

  void updateConfirmPassword({String update}) {
    _confirmPassword = update;
    _checkPasswordMatching();
  }

  void updateGender({String newGender}) {
    if (_gender != newGender) {
      _gender = newGender;
      _errorMessages[6] = null;
      notifyMyListeners();
    }
  }

  void updateCity({String newProvince}) {
    if (_province != newProvince) {
      _province = newProvince;
      _errorMessages[5] = null;
      notifyMyListeners();
    }
  }

  String _checkPasswordMatching() {
    var pwd = _textControllers[3].text;
    var cpwd = _textControllers[4].text;
    return pwd.isNotEmpty && cpwd.isNotEmpty && pwd == cpwd ? null : 'لايوجد تطابق في كلمات المرور';
  }

  void showState() {
    print(_firstName);
    print(_lastName);
    print(_email);
    print(_password);
    print(_gender);
    print(_province);
  }

  Map<String, String> fetchDataAsMap() => {
        'firstName': _textControllers[0].text.trim(),
        'lastName': _textControllers[1].text.trim(),
        'email': _textControllers[2].text.trim(),
        'password': _textControllers[3].text.trim(),
        'gender': _gender,
        'province': _province,
      };

  Future<void> loadAllCountries() async {
    String data = await rootBundle.loadString('assets/iraq_schools_and_unis/all_world_countries.json');
    _allCountries = List<String>.from(json.decode(data)['countries']);
  }
}
