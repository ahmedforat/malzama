

enum AccountType  {
    COLLEGE_LECTURER,
    COLLEGE_STUDENT,
    SCHOOL_TEACHER,
    SCHOOL_STUDENT
}

class References{

// the timeout duratio for any http request
static final Duration timeout =  Duration(seconds: 12);

  static final Map<String, String> accountTypeDictionary = {
    'AccountType.COLLEGE_LECTURER': 'College Doctor',
    'AccountType.COLLEGE_STUDENT': 'College Student',
    'AccountType.SCHOOL_STUDENT': 'School Student',
    'AccountType.SCHOOL_TEACHER': 'School Teacher'
  
  };

  static final Map<String, String> iraqProvinces = {
    'baghdad': 'بغداد',
    'anbar': 'الأنبار',
    'babil': 'بابل',
    'basrah': 'البصرة',
    'nasereya': 'ذي قار',
    'deyala': 'ديالى',
    'karbala': 'كربلاء',
    'karkook': 'كركوك',
    'mesan': 'ميسان',
    'semawa': 'السماوة',
    'najaf': 'النجف',
    'mousl': 'الموصل',
    'qadeseya': 'القادسية',
    'salah_aldeen': 'صلاح الدين',
    'kut': 'الكوت',
  };

  static  final  Map<String, String> classes = {
    'islamic': 'التربية الاسلامية',
    'arabic': 'اللغة العربية',
    'english': 'اللغة الانكليزية',
    'french': 'اللغة الفرنسية',
    'biology': 'الاحياء',
    'math': 'الرياضيات',
    'chemistry': 'الكيمياء',
    'physics': 'الفيزياء'
  };
}