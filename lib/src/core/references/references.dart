import '../../features/home/models/materials/college_material.dart';
import '../../features/home/models/materials/school_material.dart';
import '../../features/home/models/materials/study_material.dart';
import '../../features/home/models/users/college_student.dart';
import '../../features/home/models/users/college_teacher.dart';
import '../../features/home/models/users/school_student.dart';
import '../../features/home/models/users/school_teacher.dart';
import '../../features/home/models/users/user.dart';
import '../general_widgets/helper_functions.dart';
import '../platform/local_database/local_caches/cached_user_info.dart';
import 'college_materials/dentist.dart';
import 'college_materials/medicine.dart';
import 'college_materials/pharmacy.dart';

class AccountType {
  static String get uniteachers => 'uniteachers';

  static String get unistudents => 'unistudents';

  static String get schteachers => 'schteachers';

  static String get schstudents => 'schstudents';
}

class References {
// the timeout duratio for any http request
  static final Duration timeout = Duration(seconds: 20);

  static final Map<String, String> accountTypeDictionary = {
    'uniteachers': 'College Doctor',
    'unistudents': 'College Student',
    'schstudents': 'School Student',
    'schteachers': 'School Teacher'
  };

  static getSuitableSchoolTeacherSpeciality(String specaility) =>
      classes[specaility];

  static getSuitableSubRegion(String subRegion) {
    switch (subRegion) {
      case 'rusafa1':
        return 'الرصافة الاولى';
        break;
      case 'rusafa2':
        return 'الرصافة الثانية';
        break;
      case 'rusafa3':
        return 'الرصافة الثالثة';
        break;
      case 'karkh1':
        return 'الكرخ الاولى';
        break;
      case 'karkh2':
        return 'الكرخ الثانية';
        break;
      case 'karkh3':
        return 'الكرخ الثالثة';
        break;
    }
  }

  static bool isTeacher(String account_type) {
    return account_type != 'schstudents';
  }

  static String getVideoLength(Map<String, dynamic> userData) {
    return isTeacher(userData['account_type'])
        ? userData['videos'].length.toString()
        : userData['saved_videos.'].length.toString();
  }

  static String getLectureLength(Map<String, dynamic> userData) {
    return isTeacher(userData['account_type'])
        ? userData['lectures'].length.toString()
        : userData['saved_lectures'].length.toString();
  }

  static User specifyAccountType(Map<String, dynamic> map) {
    switch (map['account_type']) {
      case 'uniteachers':
        return CollegeTeacher.fromJSON(map);
        break;
      case 'unistudents':
        return CollegeSutdent.fromJSON(map);
        break;
      case 'schteachers':
        return SchoolTeacher.fromJSON(map);
        break;
      case 'schstudents':
        return SchoolStudent.fromJSON(map);
        break;
      default:
        return null;
        break;
    }
  }

  static String getSuitableSchholSection(String key) =>
      key == 'bio' ? 'الفرع الاحيائي' : 'الفرع التطبيقي';
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

  static final Map<String, String> classes = {
    'islamic': 'التربية الاسلامية',
    'arabic': 'اللغة العربية',
    'english': 'اللغة الانكليزية',
    'french': 'اللغة الفرنسية',
    'biology': 'الاحياء',
    'math': 'الرياضيات',
    'chemistry': 'الكيمياء',
    'physics': 'الفيزياء'
  };

  static Map stagesMapper = {
    '1': 'المرحلة الاولى',
    '2': 'المرحلة الثانية',
    '3': 'المرحلة الثالثة',
    '4': 'المرحلة الرابعة',
    '5': 'المرحلة الخامسة',
    '6': 'المرحلة السادسة'
  };

  static List<String> schoolStages = [
    'السادس الاعدادي',
    'الخامس الاعدادي',
    'الرابع الاعدادي',
    'الثالث متوسط',
    'الثاني متوسط',
    'الاول متوسط',
  ];

  static Map<int, String> stages = {
    1: schoolStages[5],
    2: schoolStages[4],
    3: schoolStages[3],
    4: schoolStages[2],
    5: schoolStages[1],
    6: schoolStages[0]
  };

  static List<String> schoolSections = [
    'الفرع الاحيائي',
    'الفرع التطبيقي',
    'الاحيائي والتطبيقي'
  ];

  static double getProperFontSize(int textLength) {
    print('this is textlength' + textLength.toString());
    if (textLength < 393)
      return 55.0;
    else if (textLength > 392 && textLength < 525)
      return 40.0;
    else if (textLength > 392 && textLength < 525)
      return 40.0;
    else
      return 35.0;
  }

  static String getVideoIDFrom({String youTubeLink}) {
    const String TYPICAL_PREFIX = 'https://www.youtube.com/watch?v=';
    int startIndex = TYPICAL_PREFIX.length;
    int endIndex = youTubeLink.indexOf('&');
    String videoID = endIndex == -1
        ? youTubeLink.substring(startIndex)
        : youTubeLink.substring(startIndex, endIndex);
    return videoID;
  }

  static String validateYoutubeLink(String link) {
    const String TYPICAL_PREFIX = 'https://www.youtube.com/watch?v=';
    return link.isEmpty
        ? 'this field is required'
        : link.contains('watch?v=') &&
                link
                        .substring(0, TYPICAL_PREFIX.length)
                        .compareTo(TYPICAL_PREFIX) ==
                    0 &&
                link.substring(0, TYPICAL_PREFIX.length) == TYPICAL_PREFIX
            ? null
            : 'Please enter a valid link';
  }

  static String getFullYouTubeUrl(String videoId) =>
      'https://www.youtube.com/watch?v=$videoId';

  static List<String> getSuitaleCollegeMaterialList(int stage, String college,
      {int semester}) {
    RegExp dentist = new RegExp(r'سنان');
    RegExp pharmacy = new RegExp(r'صيدلة');
    RegExp analysis = new RegExp(r'مرضية');

    if (dentist.hasMatch(college)) {
      return DentistrySyllabus.getByStage(stage);
    } else if (pharmacy.hasMatch(college)) {
      return PharmacySyllabus.getByStageAndSemester(stage, semester);
    } else if (analysis.hasMatch(college)) {
      return PharmacySyllabus.getByStageAndSemester(stage, semester);
    } else {
      return MedicineSyllabus.getByStageAndSemester(stage, semester);
    }
  }

  static StudyMaterial getProperStudyMaterial(
      Map<String, dynamic> data, bool isAcademic) {
    return isAcademic
        ? CollegeMaterial.fromJSON(data)
        : SchoolMaterial.fromJSON(data);
  }

  static Future<String> getMaterialType(
      {String text, String accountType}) async {
    bool isAcademic;
    if (accountType != null) {
      isAcademic = HelperFucntions.isAcademic(accountType);
    } else {
      accountType = await UserCachedInfo().getRecord('account_type');
      isAcademic = HelperFucntions.isAcademic(accountType);
    }
    return isAcademic ? 'uni$text' : 'sch$text';
  }
// text.length <= 128  => ScreenUtil.setSp(65)
// 128 < text.length < 145  => ScreenUtil.setSp(60)
// 144 < text.length < 181  => ScreenUtil.setSp(55)
// 180 < text.length < 221  => ScreenUtil.setSp(50)
// 220 < text.length < 265 => ScreenUtil.setSp(45)
// 264<   text.length < 352 => ScreenUtil.setSp(40)
}
