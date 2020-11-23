import 'college_user.dart';

class CollegeTeacher extends CollegeUser {
  String speciality;

  CollegeTeacher.fromJSON(Map<String, dynamic> json)
      : speciality = json['speciality'],
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'speciality': speciality,
      }..addAll(super.toJSON());
}
