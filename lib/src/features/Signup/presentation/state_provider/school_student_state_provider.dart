import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../core/platform/services/caching_services.dart';

class SchoolStudentPostSignUpState with ChangeNotifier {
  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;

  @override
  void dispose() {
    print('School State Provider has been disposed');
    super.dispose();
  }

  Future<void> initialize() async {
    await this.loadAllSchools();
    this.reset();
    _isCompleted = true;
    notifyListeners();
  }

  final RegExp femaleSchool = RegExp(r'للبنات|للمتميزات');

  //**********************************************************************************
  // this is related to the state of the raised button in the commonSignUp page
  bool _isLoading = false;
  bool get isloading => _isLoading;

  void setLoadingTo(bool update) {
    _isLoading = update;
    notifyListeners();
  }
  //**********************************************************************************

  void reset() {
    _schoolList = null;
    _schoolSection = null;
    _baghdadSubRegion = null;
    _school = null;
    _speciality = null;
  }

  String _speciality;
  String get speciality => _speciality;
  void updateSpeciality({String update}) {
    if (_speciality != update) {
      _speciality = update;
      notifyListeners();
    }
  }

  Map<String, dynamic> _schoolList;
  Map<String, dynamic> _allSchools;
  Map<String, dynamic> get schoolList => _schoolList;
  List<String> _sortedSchoolList;

  List<String> get sortedSchoolList => _sortedSchoolList;

  Future<void> updateSchoolList({String name}) async {
    String data = await CachingServices.getField(key: 'commonState');
    String gender = json.decode(data)['gender'];
    _school = null;
    print('updating school list');
    _schoolList = _allSchools[name.trim()];
    print(_schoolList);
    _schoolList.removeWhere((k, v) => !v.contains(_schoolSection));
    _schoolList.removeWhere((k, v) => gender == 'female'
        ? !femaleSchool.hasMatch(k)
        : femaleSchool.hasMatch(k));
    _sortedSchoolList = _schoolList.keys.toList();
    _sortedSchoolList.sort();

    notifyListeners();
  }

  Future<void> loadAllSchools() async {
    if (_allSchools == null) {
      String data = await rootBundle
          .loadString('assets/iraq_schools_and_unis/all_schools.json');
      _allSchools = json.decode(data);
    }
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
      notifyListeners();
    }
  }

  Map<String, dynamic> fetchStudentData(Map<String, dynamic> commonState) {
    return commonState
      ..addAll({
        'subRegion': _baghdadSubRegion,
        'school_section': _schoolSection,
        'school': _school
      });
  }

  Map<String, dynamic> fetchTechertData(Map<String, dynamic> commonState) {
    return commonState
      ..addAll({
        'subRegion': _baghdadSubRegion,
        'school_section': _schoolSection,
        'school': _school,
        'speciality': _speciality
      });
  }
  void setState() {
    notifyListeners();
  }
}
