class DentistrySyllabus {
  static List<String> get stage1 => _stage1;
  static List<String> get stage2 => _stage2;
  static List<String> get stage3 => _stage3;
  static List<String> get stage4 => _stage4;
  static List<String> get stage5 => _stage5;

  static List<String> getByStage(int stage) {
    switch (stage) {
      case 1:
        return _stage1;
        break;
      case 2:
        return _stage2;
        break;
      case 3:
        return _stage3;
        break;
      case 4:
        return _stage4;
        break;
      default :
        return _stage5;
        break;
    }
  }

  static List<String> _stage1 = [
    'Human Anatomy',
    'Dental Anatomy',
    'Biology',
    'Chemistry',
    'Human Rights and democracy',
    'terminology',
    'Medical Physics',
    'Lab- human anatomy',
    'Lab- dental anatomy',
    'Lab- biology',
    'Lab- chemistry',
    'Lab- medical physics'
  ];
  static List<String> _stage2 = [
    'Embryology',
    'O.Histology',
    'Physiology',
    'Histology',
    'Prosthodontics',
    'Biochemistry',
    'Dental Material',
    'Computer',
    'Anatomy',
    'Lab- embryology',
    'Lab- o.histology',
    'Lab- physiology',
    'Lab- prosthodontics',
    'Lab- biochemistry',
    'Lab- computer',
    'Lab- anatomy'
  ];
  static List<String> _stage3 = [
    'Crown and Bridge',
    'Conservative',
    'Prosthodontics',
    'O.Surgery',
    'Community',
    'Radiology',
    'Pharmacology',
    'Pathology',
    'microbiology',
    'Lab- crown and bridge',
    'Lab- conservative',
    'Lab- prosthodontics',
    'Lab- o.surgery',
    'Lab- community',
    'Lab- radiology',
    'Lab- pharmacology',
    'Lab- pathology',
    'Lab- microbiology'
  ];
  static List<String> _stage4 = [
    'O.Pathology',
    'G. Medicine',
    'Prosthodontics',
    'Orthodontics',
    'Pedodontics',
    'Periodontology',
    'Conservative',
    'Endodontic',
    'G surgery',
    'Lab- o.pathology',
    'Lab- g.medicine',
    'Lab- prosthodontics',
    'Lab- orthodontics',
    'Lab- pedodontics',
    'Lab- periodontology',
    'Lab- conservative',
    'Lab- endodontic',
    'Lab- g surgery'
  ];
  static List<String> _stage5 = [
    'O.Medicine',
    'Periodontology',
    'Prosthodontics',
    'Crown and bridge',
    'O.Surgery',
    'Orthodontics',
    'Prevention',
    'Pedo',
    'Lab- o.medicine',
    'Lab- periodontology',
    'Lab- prosthodontics',
    'Lab- crown and bridge',
    'Lab- o.surgery',
    'Lab- orthodontics',
    'Lab- prevention',
    'Lab- pedo'
  ];
}
