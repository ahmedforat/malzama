import './college_user.dart';

class CollegeSutdent extends CollegeUser {
  int stage;

  CollegeSutdent.fromJSON(Map<String, dynamic> json)
      : stage = int.parse(json['stage'].toString()),
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'stage': stage,
      }..addAll(super.toJSON());
}
