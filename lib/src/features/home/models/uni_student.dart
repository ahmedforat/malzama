

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:malzama/src/features/home/models/unified_model.dart';

class UniStudent{
  CommonFields commonFields;
  String university;
  String college;
  String section;
  String stage;
  List saved_lectures;
  List saved_videos;

  UniStudent({this.commonFields,this.university, this.college, this.section, this.stage,this.saved_lectures,this.saved_videos});

factory UniStudent.fromJSON({Map map}){
  return UniStudent(
    commonFields: CommonFields.fromJSON(map: map),
    university: map['university'],
    college: map['college'],
    section: map['section'],
    stage: map['stage'].toString(),
    saved_lectures: map['saved_lectures'],
    saved_videos: map['saved_videos'],
  );
}

  Map toJSON() => {
    'university':this.university,
    'college':this.college,
    'section':this.section,
    'stage':this.stage,
    'saved_lectures': this.saved_lectures,
    'saved_videos': this.saved_videos,
  }..addAll(commonFields.toJSON());
}
