import 'study_material.dart';

class SchoolMaterial extends StudyMaterial {
  String school;
  String schoolSection;
  SchoolMaterial();

  SchoolMaterial.fromJSON(Map<String, dynamic> json)
      : school = json['school'],
        schoolSection = json['school_section'],
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        'school': school,
        'school_section': schoolSection,
      }..addAll(super.toJSON());
}
