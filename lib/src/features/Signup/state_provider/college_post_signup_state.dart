import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';

class CollegePostSignUpState with ChangeNotifier {

  final Map<int, String> _stageDictionary = {
    1: 'المرحلة الاولى',
    2: 'المرحلة الثانية',
    3: 'المرحلة الثالثة',
    4: 'المرحلة الرابعة',
    5: 'المرحلة الخامسة',
    6: 'المرحلة السادسة',
  };

  String _university;
  String _college;
  String _section;
  String _stage;
  List<dynamic> _collegeList;
  Map<String,dynamic> _allUniversitiesAndCollege;
  List<String> _sectionsList;
  int _collegeStages;
  bool _isLoading = false;
  String _speciality;
  String _errorMessage;





  String get errorMessage => _errorMessage;

  

  int get collegeStages => _collegeStages;

  List<String> get sections => _sectionsList;


  List<dynamic> get collegeList => _collegeList;
  List<String> get universitiesList => _allUniversitiesAndCollege.keys.toList();


  String get speciality => _speciality;

  bool get isLoading => _isLoading;

  String get university => _university;

  String get college => _college;

  String get section => _section;

  String get stage => _stage;



  void updateErrorMessage({String update}){
    if(_errorMessage != update){
      _errorMessage = update;
      notifyListeners();
    }
  }


  void setLoadingStateTo(bool update){
    _isLoading = update;
    notifyListeners();
  }


  void updateUniversity({String update}){
    if(_university != update){
      _university = update;
      updateCollegeList(name: update);
      print(_collegeList[0].last);
      _college = null;
      _section = null;
      _stage = null;
      notifyListeners();
    }
  }

  void updateCollege({String update}){
    RegExp guessSection = new RegExp(r'طب|صيدلة|مرضية');
    if(_college != update){
      _college = update;
      _section = guessSection.hasMatch(update) ? update : null;
      _stage = null;
      for(int i = 0; i < _collegeList.length; i++){
        print(_collegeList);
        if(_collegeList[i][0] == update ){
          _collegeStages = _collegeList[i][1];
          print(_collegeStages);
          notifyListeners();
          return;
        }
      }

    }
  }

  void updateSpeciality({String update}){
    if(_speciality != update){
      _speciality = update;
      notifyListeners();
    }
  }


  void updateSection({String update}){
    if(_section != update){
      _section = update;
      notifyListeners();
    }
  }

  void updateStage({String update}){
    if(_stage != update){
      _stage = update;
      notifyListeners();
    }
  }

  Future<void> loadAllUniversitiesAndColleges()async{
   if(_allUniversitiesAndCollege == null){
     String data = await rootBundle.loadString('assets/iraq_schools_and_unis/all_unis.json');
     _allUniversitiesAndCollege = json.decode(data);
   }
  }

  void updateCollegeList({String name})async{
   _collegeList = _allUniversitiesAndCollege[name];
  }


  void showState(){
    print(_university);
    print(_college);
    print(_section);
    print(_stage);
  }

  Map<String,String> fetchStudentData(CommonWidgetsStateProvider commonState){
    return commonState.fetchDataAsMap()..addAll({
    'university':_university,
    'college':_college,
    'section':_section,
    'stage':_stageDictionary.entries.firstWhere((entry) => entry.value == _stage).key.toString()
  });
  }


  Map<String,String> fetchLecturerData(CommonWidgetsStateProvider commonState){
    return commonState.fetchDataAsMap()..addAll({
      'university':_university,
      'college':_college,
      'speciality':_speciality
    });
  }
 


}
