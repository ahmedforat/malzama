import 'school_user.dart';

class SchoolTeacher extends SchoolUser {
  String speciality;
  List<String> lectures;
  List<String> videos;
  List<String> quizes;
  List<String> subscribers;
  List<int> stages;

  SchoolTeacher.fromJSON(Map<String, dynamic> json)
      : speciality = json['speciality'],
        lectures = json['lectures'],
        videos = json['videos'],
        quizes = json['quizes'],
        subscribers = json['subscribers'];

  Map<String, dynamic> toJSON() => {
        'speciality': speciality,
        'lectures': lectures,
        'videos': videos,
        'quizes': quizes,
        'subscribers': subscribers,
      }..addAll(super.toJSON());
}
