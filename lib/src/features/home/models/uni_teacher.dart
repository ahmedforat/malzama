import 'dart:convert';

import 'package:malzama/src/features/home/models/school_teacher_model.dart';
import 'package:malzama/src/features/home/models/unified_model.dart';

class UniTeacher {
  CommonFields commonFields;
  String university;
  String college;
  String section;
  String speciality;
  String notifications_repo;
  List<String> lectures;
  List<String> videos;
  List<String> quizes;
  List<String> saved_lectures;
  List<String> saved_videos;
  List<String> saved_quizes;
  List<Subscriber> subscribers;

  UniTeacher(
      {
      this.commonFields,
      this.university,
      this.college,
      this.section,
      this.speciality,
      this.notifications_repo,
      this.videos,
      this.lectures,
      this.quizes,
      this.saved_lectures,
      this.saved_videos,
      this.saved_quizes,
      this.subscribers});

  factory UniTeacher.fromJSON({Map<String,dynamic> map}) {
    return UniTeacher(
        commonFields: CommonFields.fromJSON(map: map),
        university: map['university'],
        college: map['college'],
        section: map['section'],
        speciality: map['speciality'],
        notifications_repo: map['notifications_repo'],
        lectures: map['lectures']?.map<String>((item) => item.toString())?.toList()??[],
        videos: map['videos']?.map<String>((item) => item.toString())?.toList()??[],
        quizes: map['quizes']?.map<String>((item) => item.toString())?.toList()??[],
        saved_lectures: map['saved_lectures']?.map<String>((item) => item.toString())?.toList()??[],
        saved_videos: map['saved_videos']?.map<String>((item) => item.toString())?.toList()??[],
        saved_quizes: map['saved_quizes']?.map<String>((item) => item.toString())?.toList()??[],
        subscribers: map['subscribers']?.map<Subscriber>((item) => new Subscriber(id: item['id'], one_signal_id: item['one_signal_id']))?.toList()??[]);
  }

  Map<String,dynamic> toJSON() => {
        'university': this.university,
        'college': this.college,
        'section': this.section,
        'speciality': this.speciality,
        'lectures': this.lectures,
        'videos': this.videos,
        'quizes': this.quizes,
        'saved_lectures': this.saved_lectures,
        'saved_videos': this.saved_videos,
        'saved_quizes': this.saved_quizes,
        'notifications_repo': this.notifications_repo,
        'subscribers': subscribers?.map((e) => e?.toJSON())?.toList()
      }..addAll(commonFields.toJSON());
}
