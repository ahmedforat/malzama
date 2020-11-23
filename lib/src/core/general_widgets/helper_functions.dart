import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/Signup/college_student_signup.dart';
import 'package:malzama/src/features/home/models/users/college_student.dart';
import 'package:malzama/src/features/home/models/users/college_teacher.dart';
import 'package:malzama/src/features/home/models/users/college_user.dart';
import 'package:malzama/src/features/home/models/users/school_student.dart';
import 'package:malzama/src/features/home/models/users/school_teacher.dart';
import 'package:malzama/src/features/home/models/users/school_user.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:path_provider/path_provider.dart';

class HelperFucntions {
  static bool isAcademic(String account_type) {
    return account_type != 'schteachers' && account_type != 'schstudents';
  }

  static bool isTeacher(String accountType) {
    return accountType == 'uniteachers' || accountType == 'schteachers';
  }

  static bool isPharmacyOrMedicine() {
    UserInfoStateProvider userInfoStateProvider = locator<UserInfoStateProvider>();
    String accountType = userInfoStateProvider.userData.accountType;
    if (!HelperFucntions.isAcademic(accountType)) {
      return false;
    }
    RegExp pharmacyPattern = new RegExp(r'صيدلة');
    RegExp dentistPattern = new RegExp(r'سنان');
    RegExp analysisPattern = new RegExp(r'مرضية');

    String college = (userInfoStateProvider.userData as CollegeUser).college;

    bool isMedicine = !dentistPattern.hasMatch(college) && !analysisPattern.hasMatch(college) && !pharmacyPattern.hasMatch(college);

    return (accountType == 'uniteachers' || accountType == 'unistudents') && (pharmacyPattern.hasMatch(college) || isMedicine);
  }

  static Future<Map<String, dynamic>> getAuthorPopulatedData() async {
    User data = await FileSystemServices.getUserData();
    print('=========================== inside getAuthorPopulated Data');
    print('=========================== inside getAuthorPopulated Data');
    var populatedData = {
      'firstName': data.firstName,
      'lastName': data.lastName,
      '_id': data.id,
      'one_signal_id': data.oneSignalId,
      'account_type': data.accountType,
      'profile_pic_ref': data.profilePicture,
      'profile_cover_ref': data.coverPicture,
      'notifications_repo': data.notificationsRepo,
      'uuid': data.uuid
    };
    return populatedData;
  }

  // get the tags map object to be sent as tags to the OneSignal Notifications Service
  static Future<Map<String, dynamic>> getUserTags() async {
    User data = await FileSystemServices.getUserData();

    Map<String, dynamic> tags;
    if (data != null) {
      switch (data.accountType) {
        case 'schstudents':
          tags = {
            'type': data.accountType,
            'sch': (data as SchoolStudent).school,
            'sec': (data as SchoolStudent).schoolSection,
            'stg': (data as SchoolStudent).stage,
            'uuid': data.uuid
          };
          break;

        case 'schteachers':
          tags = {
            'type': data.accountType,
            'sch': (data as SchoolTeacher).school,
            'speciality': (data as SchoolTeacher).speciality,
            'stgs': (data as SchoolTeacher).stages,
            'uuid': data.uuid
          };
          break;

        case 'unistudents':
          tags = {
            'type': data.accountType,
            'uni': (data as CollegeSutdent).university,
            'col': (data as CollegeSutdent).college,
            'stg': (data as CollegeSutdent).stage,
            'sec': (data as CollegeSutdent).section,
            'uuid': data.uuid
          };
          break;

        case 'uniteachers':
          tags = {
            'type': data.accountType,
            'uni': (data as CollegeTeacher).university,
            'col': (data as CollegeTeacher).college,
            'sec': (data as CollegeTeacher).section,
            'uuid': data.uuid
          };
          break;
      }
    }
    return tags;
  }

//  static Future<Map<String,dynamic>> getPopulatedAuthorData()async{
//    var data = await FileSystemServices.getUserData();
//
//    return {
//      'firstName':data['firstName'],
//      'lastName':data['lastName'],
//      '_id':'_id',
//    };
//  }

  static Future<String> getAcademicUUID({@required String university, @required String college}) async {
    String data = await rootBundle.loadString('assets/iraq_schools_and_unis/all_unis.json');
    Map<String, dynamic> allUniversities = json.decode(data);
    Map<String, List<List>> universities = {};
    allUniversities.entries.toList().forEach((e) {
      universities[e.key] = [...e.value];
    });
    final String uuid = universities[university].firstWhere((element) => element.first.toString().trim() == college.trim()).last;
    return uuid;
  }

  static Future<String> getSchoolUUID({@required String region, @required String school}) async {
    String data = await rootBundle.loadString('assets/iraq_schools_and_unis/schools.json');
    Map<String, dynamic> allSchools = json.decode(data);
    Map<String, Map<String, List<dynamic>>> schools = {};
    allSchools.entries.toList().forEach((element) {
      Map<String, List> temp = element.value;
      schools[element.key] = temp;
    });
    final String uuid = schools[region][school].last;
    return uuid;
  }

  static Future<String> getUUID() async {
    UserInfoStateProvider userInfoProvider = locator<UserInfoStateProvider>();
    if (userInfoProvider.isAcademic) {
      CollegeUser collegeUser = userInfoProvider.userData;
      final String college = collegeUser.college;
      final String university = collegeUser.university;
      return await getAcademicUUID(university: university, college: college);

    }
    SchoolUser schoolUser = userInfoProvider.userData;
    final String school = (userInfoProvider.userData as SchoolUser).school;
    final String region = schoolUser.subRegion ?? schoolUser.province;
    return await getSchoolUUID(region: region, school: school);
  }
}
