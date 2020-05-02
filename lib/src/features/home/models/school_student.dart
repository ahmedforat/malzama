

import 'dart:convert';

import 'package:malzama/src/features/home/models/unified_model.dart';

class SchoolStudent{
  CommonFields commonFields;
  String school;
  String school_section;
  String bio;
  List saved_lectures;
  List saved_videos;

  SchoolStudent({this.commonFields,this.school,this.school_section,this.bio,this.saved_videos,this.saved_lectures});

  factory SchoolStudent.fromJSON({Map map}){
    return new SchoolStudent(
      commonFields : CommonFields.fromJSON(map: map),
      school: map['school'],
      school_section: map['school_section'],
      bio: map['bio'],
      saved_lectures: map['saved_lectures'],
      saved_videos: map['saved_videos'],
    );
  }


  Map toJSON() => {
    'school':this.school,
    'school_section':this.school_section,
    'bio':this.bio,
    'saved_lectures': this.saved_lectures,
    'saved_videos': this.saved_videos,
  }..addAll(this.commonFields.toJSON());
}