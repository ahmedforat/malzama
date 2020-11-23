import 'study_material.dart';

class CollegeMaterial extends StudyMaterial {
  String college;
  String university;
  String section;
  int semester;

  CollegeMaterial();

  CollegeMaterial.fromJSON(Map<String, dynamic> json)
      : college = json['college'],
        university = json['university'],
        section = json['section'],
        semester = json['semester'] == null ? null :int.parse(json['semester'].toString()),
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'college': college,
        'university': university,
        'section': section,
        'semester': semester,
      }..addAll(super.toJSON());
}
