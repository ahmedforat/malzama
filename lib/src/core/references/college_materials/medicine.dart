import 'package:flutter/foundation.dart';

class MedicineSyllabus {
  
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
        
      case 5:
       return semester == 1 ? _stage5Course1 : _stage5Course2;
       break;

      case 6:
        return _stage6Course1;
        break;

      default:
        return ['No Items available'];
        break;
    }
  }
}



// stage 1
List<String> _stage1Course1 = [
  'Computer I',
  'Human Anatomy I',
  'Biology,Empryology,Histology(BHDT)',
  'Medical Physics',
  'Medical and English',
  'Arabic Language'
];
List<String> _stage1Course2 = [
  'Systemic Module (Respiratory)',
  'Systemic Module (Cardiovascular)',
  'Systemic Module (Hematology)',
  'Human Anatomy II',
  'Computer II',
  'Medical Ethics',
  'Biochemistry',
  'English II',
  'Human Rights and Democracy'
];

//  stage 2
List<String> _stage2Course1 = [
  'Human Structure and Functions 3 Module',
  'Genetic Basis of Disease',
  'Principles of Pharmacology Module',
  'Neuroscience',
  'Clinical Lab Science',
  'Basic Life Support'
];
List<String> _stage2Course2 = [
  'Digestive System Module',
  'Endocrie and Reporductive',
  'Early Clinical & Professional Development Module',
  'Principles of Public Health',
  'Urinary System'
];

// stage 3
List<String> _stage3Course1 = [
  'Clinical Attachment Module',
  'Nutrition,Water & Electrolyte Module',
  'Research Methodology Module',
  'Infectious Disease Module I'
];
List<String> _stage3Course2 = [
  'Clinical Attachment Module',
  'Infectious Diseases Module II',
  'Immune Disturbances',
  'Primary Health Care Module',
  'Research Proposal'
];

// stage 4
List<String> _stage4Course1 = [
  'Surgical Module',
  'Hematology',
  'Cardiovascular Module',
  'Respiratory System',
  'Forensic Medicine',
  'Clinical Pharmacology I',
  'Clinical Skills',
  'Research Project Part II'
  ];
List<String> _stage4Course2 = [
  'Endocrine Module',
  'Urinary Module & Male Genital',
  'GIT & Liver Module',
  'Clinical Pharmacology II',
  'Behavioral Science'
];
// stage 5 
List<String> _stage5Course1 = [
  'Pediatrics I',
  'Women Health I',
  'Rheumatology I',
  'Psychiatry I',
  'Dermatology I',
  'Neuroscience I',
  'Orthopedics',
  'Ear,Nose & Throat (ENT)',
  'Opthalmology I'
];
List<String> _stage5Course2 = [
  'Pediatrics II',
  'Women Health II',
  'Rheumatology II',
  'Dermatology II',
  'Neuroscience II',
  'Psychiatry II',
  'Orthopedics II',
  'Ear,Nose & Throat II (ENT)',
  'Opthalmology II'

];

// stage 6 (stageer)
List<String> _stage6Course1 = [
  'Medicine',
  'Obstetrics & Gyn',
  'Surgery',
  'Pediatrics'
];
List<String> _stage6Course2 = [];
