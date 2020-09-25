import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:malzama/src/features/home/models/unified_model.dart';

class SchoolTeacher {
  CommonFields commonFields;
  String school;
  String school_section;
  String speciality;
  String bio;
  String notifications_repo;
  List<String> lectures;
  List<String> videos;
  List<String> quizes;
  List<String> saved_lectures;
  List<String> saved_videos;
  List<String> saved_quizes;
  List<Subscriber> subscribers;

  SchoolTeacher({this.commonFields,
    this.school,
    this.school_section,
    this.speciality,
    this.bio,
    this.videos,
    this.lectures,
    this.quizes,
    this.saved_lectures,
    this.saved_videos,
    this.saved_quizes,
    this.notifications_repo,
    this.subscribers});

  factory SchoolTeacher.fromJSON({Map<String,dynamic> map}) =>
      SchoolTeacher(
          commonFields: CommonFields.fromJSON(map: map),
          school: map['school'],
          school_section: map['school_section'],
          bio: map['bio'],
          speciality: map['speciality'],
          notifications_repo: map['notifications_repo'],
          lectures: map['lectures']?.map<String>((item) => item?.toString())?.toList()??[],
          videos: map['videos']?.map<String>((item) => item?.toString())?.toList()??[],
          quizes: map['quizes']?.map<String>((item) => item?.toString())?.toList()??[],
          saved_lectures: map['saved_lectures']?.map<String>((item) => item?.toString())?.toList()??[],
          saved_videos: map['saved_videos']?.map<String>((item) => item?.toString())?.toList()??[],
          saved_quizes: map['saved_quizes']?.map<String>((item) => item?.toString())?.toList()??[],
          subscribers: map['subscribers']?.map<Subscriber>(
                  (item) => new Subscriber(id: item['id'], one_signal_id: item['one_signal_id'])
          )?.toList());

  Map<String,dynamic> toJSON() =>
      {
        'school': this.school,
        'school_section': this.school_section,
        'bio': this.bio,
        'speciality': this.speciality,
        'lectures': this.lectures,
        'videos': this.videos,
        'quizes': this.quizes,
        'saved_lectures': this.saved_lectures,
        'saved_videos': this.saved_videos,
        'saved_quizes': this.saved_quizes,
        'notifications_repo': this.notifications_repo,

      }
        ..addAll(commonFields.toJSON());
}

class Subscriber {
  String id, one_signal_id;

  Subscriber({@required this.id, @required this.one_signal_id});

  Subscriber.fromJSON(Map<String, dynamic> map)
      : id = map['id'],
        one_signal_id = map['one_signal_id'];

  toJSON() => {'id': id, 'one_signal_id': one_signal_id};
}
