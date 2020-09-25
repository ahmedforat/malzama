import 'dart:convert';

import 'package:malzama/src/features/home/models/unified_model.dart';

class SchoolStudent {
  CommonFields commonFields;
  String school;
  String school_section;
  String bio;
  List<String> saved_lectures;
  List<String>  saved_videos;
  List<String>  saved_quizes;
  String notifications_repo;
  String stage;

  SchoolStudent({
    this.commonFields,
    this.school,
    this.school_section,
    this.bio,
    this.saved_videos,
    this.saved_lectures,
    this.saved_quizes,
    this.notifications_repo,
    this.stage
  });

  factory SchoolStudent.fromJSON({Map<String,dynamic> map}) {
    return new SchoolStudent(
        commonFields: CommonFields.fromJSON(map: map),
        school: map['school'],
        school_section: map['school_section'],
        stage: map['stage'].toString(),
        saved_lectures: map['saved_lectures']?.map<String> ((item) => item?.toString())?.toList() ?? [],
        saved_videos: map['saved_videos']?.map<String> ((item) => item?.toString())?.toList() ?? [],
        saved_quizes: map['saved_quizes']?.map<String> ((item) => item?.toString())?.toList() ?? [],
        notifications_repo: map['notifications_repo'],);
  }

  Map<String,dynamic> toJSON() => {
        'school': this.school,
        'school_section': this.school_section,
        'bio': this.bio,
        'saved_lectures': this.saved_lectures,
        'saved_videos': this.saved_videos,
        'notifications_repo': notifications_repo,
        'stage':this.stage
      }..addAll(this.commonFields.toJSON());
}
