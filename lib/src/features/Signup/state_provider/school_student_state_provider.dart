import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


class SchoolStudentPostSignupState with ChangeNotifier {

  //**********************************************************************************
  // this is related to the state of the raised button in the commonSignUp page
  bool _isLoading = false;
  bool get isloading => _isLoading;



  void setLoadingTo(bool update){
    _isLoading = update;
    notifyListeners();
  }
  //**********************************************************************************

  void nulifyAll(){
    _schoolList = null;
    _schoolSection = null;
    _baghdadSubRegion = null;
  }

  Map<String, dynamic> _schoolList;
  Map<String,dynamic> _allSchools;

  Map<String, dynamic> get schoolList => _schoolList;

  Future<void> updateSchoolList({String name}) async{
    _school = null;
    print(name);
    print(_allSchools.keys.toList());
    print(_allSchools.containsKey(name));
    _schoolList = _allSchools[name.trim()];
    print(_schoolList);
    _schoolList.removeWhere((k,v) => !v.contains(_schoolSection));

    notifyListeners();
  }

  Future<bool> prepareAllSchools()async{
    if(_allSchools == null){
      String data = await rootBundle.loadString('assets/iraq_schools_folder/all_schools.json');
      _allSchools = json.decode(data);
    }
    return true;
  }

  String _baghdadSubRegion;

  String get baghdadSubRegion => _baghdadSubRegion;

  void updateBaghdadSubRegion({String update}) {
    if (_baghdadSubRegion != update) {
      _baghdadSubRegion = update;
      notifyListeners();
    }
  }

  String _school;

  String get school => _school;

  void updateSchool({String update}) {
    if (_school != update) {
      _school = update;
      notifyListeners();
    }

  }

  String _schoolSection;

  String get schoolSection => _schoolSection;

  void updateSchoolSection({String update}) {
    if (_schoolSection != update) {
      _schoolSection = update;
    }
  }

  void setState(){
    notifyListeners();
  }
}
