import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:malzama/src/features/signup/state_provider/school_student_state_provider.dart';

enum AccountType  {
    COLLEGE_LECTURER,
    COLLEGE_STUDENT,
    SCHOOL_TEACHER,
    SCHOOL_STUDENT
}
class CommonWidgetsStateProvider with ChangeNotifier {

  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _province;
  String _gender;
  String _phone;
  String _university;
  String _college;
  String _section;
  String _stage;
  String _speciality;
  AccountType _accountType;
  List<String> _allCountries;

  List<String> get  allCountries => _allCountries;



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

  String get province => _province;

  String get gender => _gender;

  String get phone => _phone;

  String get speciality => _speciality;





  void updateSpeciality({String update}) {
    if (_speciality != update) {
      _speciality = update;
      notifyListeners();
    }
  }

  void updateStage({String update}) {
    if (_stage != update) {
      _stage = update;
      notifyListeners();
    }
  }

  void updateUniversity({String update}) {
    if (_university != update) {
      _university = update;
      notifyListeners();
    }
  }

  void updateCollege({String update}) {
    if (_college != update) {
      _college = update;
      notifyListeners();
    }
  }

  void updateSection({String update}) {
    if (_section != update) {
      _section = update;
      notifyListeners();
    }
  }




  void updateFirstName({String update}) {
    _firstName = update;
  }

  void updateLastName({String update}) {
    _lastName = update;
  }

  void updateEmail({String update}) {
    _email = update;
  }

  void updatePassword({String update}) {
    _password = update;
  }

  void updateGender({String newGender}) {
    if (_gender != newGender) {
      _gender = newGender;
      notifyListeners();
    }
  }

  void updatePhone({String update}) {
    _phone = update;
  }

  void updateCity({String newProvince,SchoolStudentPostSignupState postSignupState}) {
    if(_province != newProvince){
      _province = newProvince;
      postSignupState.nulifyAll();
      notifyListeners();
    }

  }

  void showState() {
    print(_firstName);
    print(_lastName);
    print(_email);
    print(_phone);
    print(_password);
    print(_gender);
    print(_province);
  }

  Map<String,String> fetchDataAsMap()
   => {
    'firstName':_firstName,
     'lastName':_lastName,
     'email':_email,
     'phone':_phone,
     'password':_password,
     'gender':_gender,
     'city':_province,
     'account_type':_accountType.toString()
   };

    Future<void> loadAllCountries()async{
    String data = await rootBundle.loadString('assets/iraq_schools_and_unis/all_world_countries.json');
    _allCountries = List<String>.from(json.decode(data)['countries']);
  }
}
