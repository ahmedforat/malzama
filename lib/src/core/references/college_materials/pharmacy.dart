// author: Karrar Mohammed Jumaa
class PharmacySyllabus {
  static List<String> getByStageAndSemester(int stage, int semester) {
    switch (stage) {
      case 1:
        return semester == 1 ? _stage1Course1 : _stage1Course2;
        break;

      case 2:
        return semester == 1 ? _stage2Course1 : _stage2Course2;
        break;

      case 3:
        return semester == 1 ? _stage3Course1 : _stage3Course2;
        break;

      case 4:
        return semester == 1 ? _stage4Course1 : _stage4Course2;
        break;

      default:
        return semester == 1 ? _stage5Course1 : _stage5Course2;
        break;
    }
  }
}

// stage 1
List<String> _stage1Course1 = [
  'Analytical Chemistry',
  'Human Biology',
  'Principles of Pharmacy',
  'Computer Science',
  'Math and Biostatistics I',
  'Medical Terminology',
  'Arabic Language',
  'English Language'
      'Lab-human biology',
  'Lab-analytical chemistry',
  'Lab-computer science'
];
List<String> _stage1Course2 = [
  'Organic Chemistry I',
  'Human Anatomy',
  'Medical Physics',
  'Histology',
  'English Language',
  'Pharmaceutical Calculations',
  'Human Rights',
  'Lab-organic chemistry I',
  'Lab-histology',
  'Lab-pharmacetutical calculations',
  'Lab-medical physics',
  'Lab-computer sciences',
  'Lab-human anatomy'
];

//  stage 2
List<String> _stage2Course1 = [
  'Organic Chemistry II',
  'Medical Microbiology',
  'Physical Pharmacy I',
  'Physiology I',
  'Democracy',
  'English Language',
  'Lab-organic chemistry II',
  'Lab-medical microbiology',
  'Lab-physical pharmacy I',
  'Lab-physiology I',
  'Lab-computer sciences'
];
List<String> _stage2Course2 = [
  'Physiology II',
  'Pharmacognosy I',
  'Parasitology',
  'Physical Pharmacy II',
  'Organic Chemistry III',
  'English Language',
  'Lab-organic chemistry III',
  'Lab-physiology II',
  'Lab-pharmacognosy I',
  'Lab-parasitology',
  'Lab-physical pharmacy II',
  'Lab-computer sciences'
];

// stage 3
List<String> _stage3Course1 = [
  'PathoPhysiology',
  'Pharmacetical Technology I',
  'Biochemistry I',
  'Pharmacognosy II',
  'Inorganic Pharm. Chemistry',
  'English Language',
  'Lab-pathophysiology',
  'Lab-pharmacognosy II',
  'Lab-biochemistry I',
  'Lab-phramaceutical technology',
  'Lab-inorganic pharm. chemistry',
];
List<String> _stage3Course2 = [
  'Pharmacology I',
  'Pharmacognosy III',
  'Biochemistry II',
  'Pharm.Technology II',
  'Org.Pharm.Chemistry I',
  'Pharmacy Ethics',
  'Lab-org.pharm.chemistry',
  'Lab-biochemistry II',
  'Lab-pharm.technology',
  'Lab-pharmacognosy III',
];

// stage 4
List<String> _stage4Course1 = [
  'Clinical Pharmacy I',
  'Pharmacology II',
  'Biopharmaceutics',
  'Org.Pharm.Chemistry II',
  'Public Health',
  'Lab-clinical pharmacy I',
  'Lab-pharmacologyII',
  'Lab-biopharmaceutics',
  'Lab-organic pharm. chemistry II'
];
List<String> _stage4Course2 = [
  'General Toxicology',
  'Pharmacology III',
  'Org.Pharm.Chemistry III',
  'Communication Skills',
  'Industrial Pharmacy I',
  'Clinical Pharmacy II',
  'Lab-industrial pharmacy I',
  'Lab-org.pharm.chemistry III',
  'Lab-clinical pharmacy',
  'Lab-general toxicology',
];

// stage 5 (stageer)
List<String> _stage5Course1 = [
  'Clinical Toxicology II',
  'Clinical Chemistry',
  'Hospital Training',
  'Lab-clinical lab. training',
  'Org.Pharm.Chemistry IV',
  'Applied Therapeutics I',
  'Industrial Pharmacy II',
  'Lab-Hospital Training',
  'Lab-clinical chemistry',
  'Lab-clinical toxicology II',
  'Lab-industrial pharmacy II',
];
List<String> _stage5Course2 = [
  'PharmacoEconomics',
  'TDM',
  'Advanced Pharm.Analysis',
  'Dosage Form Design',
  'Applied Therapeutics II',
  'Pharm. Biotechnology',
  'Lab-advanced pharm.anaylysis',
  'Lab-TDM',
  'Lab- hospital training',
  'Lab- clinical lab. training',
];
