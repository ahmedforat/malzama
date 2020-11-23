import 'school_user.dart';

class SchoolStudent extends SchoolUser {
  int stage;

  SchoolStudent.fromJSON(Map<String, dynamic> json)
      : stage = int.parse(json['stage'].toString()),
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'stage': stage,
      }..addAll(super.toJSON());
}
