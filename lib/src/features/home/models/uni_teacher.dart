
import 'dart:convert';

import 'package:malzama/src/features/home/models/unified_model.dart';

class UniTeacher{
  CommonFields commonFields;
  String university;
  String college;
  String section;
  String speciality;
  List lectures;
  List videos;

  UniTeacher({this.commonFields,this.university, this.college, this.section, this.speciality,this.lectures,this.videos});

  factory UniTeacher.fromJSON({Map map}){
    return UniTeacher(
        commonFields: CommonFields.fromJSON(map: map),
        university: map['university'],
        college: map['college'],
        section: map['section'],
        speciality: map['speciality'],
        lectures: map['lectures'],
        videos: map['videos'],

    );
  }

  Map toJSON() => {
    'university':this.university,
    'college':this.college,
    'section':this.section,
    'speciality':this.speciality,
    'lectures': this.lectures,
    'videos': this.videos,
  }..addAll(commonFields.toJSON());
}