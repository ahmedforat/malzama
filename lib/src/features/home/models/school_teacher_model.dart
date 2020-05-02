import 'dart:convert';

import 'package:malzama/src/features/home/models/unified_model.dart';

class SchoolTeacher {
  CommonFields commonFields;
  String school;
  String school_section;
  String speciality;
  String bio;
  List lectures;
  List videos;

  SchoolTeacher(
      {this.commonFields,
      this.school,
      this.school_section,
      this.speciality,
      this.bio,
      this.videos,
      this.lectures});

  factory SchoolTeacher.fromJSON({Map map}) => SchoolTeacher(
        commonFields: CommonFields.fromJSON(map: map),
        school: map['school'],
        school_section: map['school_section'],
        bio: map['bio'],
        speciality: map['speciality'],
        lectures: map['lectures'],
        videos: map['videos'],
      );

  Map toJSON() => {
        'school': this.school,
        'school_section': this.school_section,
        'bio': this.bio,
        'speciality': this.speciality,
        'lectures': this.lectures,
        'videos': this.videos
      }..addAll(this.commonFields.toJSON());
}
