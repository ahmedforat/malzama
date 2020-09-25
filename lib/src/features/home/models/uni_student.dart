import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:malzama/src/features/home/models/unified_model.dart';

class UniStudent {
  CommonFields commonFields;
  String university;
  String college;
  String section;
  String stage;
  String notifications_repo;
  List<String> lectures;
  List<String> videos;
  List<String> quizes;
  List<String> saved_lectures;
  List<String> saved_videos;
  List<String> saved_quizes;

  UniStudent({
    this.commonFields,
    this.university,
    this.college,
    this.section,
    this.stage,
    this.notifications_repo,
    this.videos,
    this.lectures,
    this.quizes,
    this.saved_lectures,
    this.saved_videos,
    this.saved_quizes,
  });

  factory UniStudent.fromJSON({Map<String,dynamic> map}) {
    return UniStudent(
      commonFields: CommonFields.fromJSON(map: map),
      university: map['university'],
      college: map['college'],
      section: map['section'],
      stage: map['stage'].toString(),
      notifications_repo: map['notifications_repo'],
      lectures: map['lectures']?.map<String>((item) => item.toString())?.toList()??[],
      videos: map['videos']?.map<String>((item) => item.toString())?.toList()??[],
      quizes: map['quizes']?.map<String>((item) => item.toString())?.toList()??[],
      saved_lectures: map['saved_lectures']?.map<String>((item) => item.toString())?.toList()??[],
      saved_videos: map['saved_videos']?.map<String>((item) => item.toString())?.toList()??[],
      saved_quizes: map['saved_quizes']?.map<String>((item) => item.toString())?.toList()??[],
    );
  }

  Map<String,dynamic> toJSON() => {
        'university': this.university,
        'college': this.college,
        'section': this.section,
        'stage': this.stage,
        'lectures': this.lectures,
        'videos': this.videos,
        'quizes': this.quizes,
        'saved_lectures': this.saved_lectures,
        'saved_videos': this.saved_videos,
        'saved_quizes': this.saved_quizes,
        'notifications_repo': this.notifications_repo,
      }..addAll(commonFields.toJSON());
}
