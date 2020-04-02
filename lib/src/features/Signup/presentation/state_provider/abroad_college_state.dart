// import 'package:flutter/material.dart';
// import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';

// class AbroadCollegeState with ChangeNotifier {
//   String _university;
//   String _college;
//   String _speciality;
//   String _universityErrorMessage;
//   String _collegeErrorMessage;
//   String _specialityErrorMessage;
//   String _currentCountry;
//   String _section;
//   String _stage;
//   String _sectionErrorMessage;
//   String _stageErrorMessage;

//   String get sectionErrorMessage => _sectionErrorMessage;
//   String get stageErrorMessage => _stageErrorMessage;
//   String get section => _section;
//   String get stage => _stage;
//   String get currentCountry => _currentCountry;
//   String get university => _university;
//   String get college => _college;
//   String get speciality => _speciality;

//   String get universityErrorMessage => _universityErrorMessage;
//   String get collegeErrorMessage => _collegeErrorMessage;
//   String get specialityErrorMessage => _specialityErrorMessage;

//   void updateUniversity({String update}) {
//     if (_university != update) {
//       _university = update;
//       notifyListeners();
//     }
//   }

//   void updateCollege({String update}) {
//     if (_college != update) {
//       _college = update;
//       notifyListeners();
//     }
//   }

//   void updateSpeciality({String update}) {
//     if (_speciality != update) {
//       _speciality = update;
//       notifyListeners();
//     }
//   }

//   void updateUniversityErrorMessage({String update}) {
//     if (_universityErrorMessage != update) {
//       _universityErrorMessage = update;
//       notifyListeners();
//     }
//   }

//   void updateCollegeErrorMessage({String update}) {
//     if (_collegeErrorMessage != update) {
//       _collegeErrorMessage = update;
//       notifyListeners();
//     }
//   }

//   void updateSpecialityErrorMessage({String update}) {
//     if (_specialityErrorMessage != update) {
//       _specialityErrorMessage = update;
//       notifyListeners();
//     }
//   }

//   void updateCurrentCountry({String update}) {
//     if (_currentCountry != update) {
//       _currentCountry = update;
//       notifyListeners();
//     }
//   }

//   void updateSectionErrorMessage({String update}) {
//     if (_sectionErrorMessage != update) {
//       _stageErrorMessage = update;
//       notifyListeners();
//     }
//   }


//   void updateStageErrorMessage({String update}) {
//     if (_stageErrorMessage != update) {
//       _stageErrorMessage = update;
//       notifyListeners();
//     }
//   }

//   void updateSection({String update}) {
//     if (_section != update) {
//       _section = update;
//       notifyListeners();
//     }
//   }


//   void updateStage({String update}) {
//     if (_stage != update) {
//       _stage = update;
//       notifyListeners();
//     }
//   }



//   Map<String, String> fetchLecturerData(
//       CommonWidgetsStateProvider commonState) {
//     return commonState.fetchDataAsMap()
//       ..addAll({
//         'university': _university,
//         'college': _college,
//         'speciality': _speciality,
//         'current_country': _currentCountry
//       });
//   }

//   Map<String, String> fetchStudentData(CommonWidgetsStateProvider commonState) {
//     return commonState.fetchDataAsMap()
//       ..addAll({
//         'university': _university,
//         'college': _college,
//         'section': _section,
//         'stage': _stage,
//         'current_country': _currentCountry
//       });
//   }
// }
