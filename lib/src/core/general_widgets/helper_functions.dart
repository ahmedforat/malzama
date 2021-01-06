import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/general_widgets/helper_utils/profile_pictures_modal_sheet.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/models/users/college_student.dart';
import 'package:malzama/src/features/home/models/users/college_teacher.dart';
import 'package:malzama/src/features/home/models/users/college_user.dart';
import 'package:malzama/src/features/home/models/users/school_student.dart';
import 'package:malzama/src/features/home/models/users/school_teacher.dart';
import 'package:malzama/src/features/home/models/users/school_user.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_saved_material/state_provider/saved_pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_saved_material/state_provider/saved_quizes_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/bio_options_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/yes_or_no_alert_dialog.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import 'helper_utils/edit_or_delete_options_widget.dart';

enum FetchingType { INITIAL, PAGINATION }

class HelperFucntions {
  static bool isAcademic(String accountType) => accountType != 'schteachers' && accountType != 'schstudents';

  static bool isTeacher(String accountType) => accountType == 'uniteachers' || accountType == 'schteachers';

  static bool isPharmacyOrMedicine() {
    UserInfoStateProvider userInfoStateProvider = locator<UserInfoStateProvider>();
    String accountType = userInfoStateProvider.userData.accountType;
    if (!HelperFucntions.isAcademic(accountType)) {
      return false;
    }

    CollegeUser collegeUser = (userInfoStateProvider.userData as CollegeUser);

    return collegeUser.isPharmacy || collegeUser.isMedical;
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

    if (data.isAcademic) {
      populatedData['college'] = (data as CollegeUser).college;
      populatedData['university'] = (data as CollegeUser).university;
      populatedData['section'] = (data as CollegeUser).section;

      if (HelperFucntions.isTeacher(data.accountType)) {
        populatedData['speciality'] = (data as CollegeTeacher).speciality;
      }
    } else {
      populatedData['school'] = (data as SchoolUser).school;
      populatedData['schoolSection'] = (data as SchoolUser).schoolSection;
      if (HelperFucntions.isTeacher(data.accountType)) {
        populatedData['speciality'] = (data as SchoolTeacher).speciality;
      }
    }
    return populatedData;
  }

  // get the tags map object to be sent as tags to the OneSignal Notifications Service
  static Future<Map<String, dynamic>> getUserTags() async {
    User data = await FileSystemServices.getUserData();

    Map<String, dynamic> tags = {
      'type': data.accountType,
      'uuid': data.uuid,
    };
    if (data != null) {
      switch (data.accountType) {
        case 'schstudents':
          tags = {
            ...tags,
            'sch': (data as SchoolStudent).school,
            'sec': (data as SchoolStudent).schoolSection,
            'stg': (data as SchoolStudent).stage,
          };
          break;

        case 'schteachers':
          tags = {
            ...tags,
            'sch': (data as SchoolTeacher).school,
            'speciality': (data as SchoolTeacher).speciality,
            'stgs': (data as SchoolTeacher).stages,
          };
          break;

        case 'unistudents':
          tags = {
            ...tags,
            'uni': (data as CollegeSutdent).university,
            'col': (data as CollegeSutdent).college,
            'stg': (data as CollegeSutdent).stage,
            'sec': (data as CollegeSutdent).section,
          };
          break;

        case 'uniteachers':
          tags = {
            ...tags,
            'uni': (data as CollegeTeacher).university,
            'col': (data as CollegeTeacher).college,
            'sec': (data as CollegeTeacher).section,
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

  static Future<void> onPdforVideoSaving<T extends MaterialStateRepository>({BuildContext context, int pos}) async {
    List<Type> _types = [MySavedVideoStateProvider, MySavedPDFStateProvider];
    if (_types.contains(T)) {
      bool val = Platform.isAndroid
          ? await showDialog(context: context, useRootNavigator: true, builder: (context) => YesOrNoAlertDialog())
          : await showCupertinoDialog(context: context, useRootNavigator: true, builder: (context) => YesOrNoAlertDialog());
      if (val) {
        Provider.of<T>(context, listen: false).onMaterialSaving(pos);
      }
    } else {
      Provider.of<T>(context, listen: false).onMaterialSaving(pos);
    }
  }

  static Future<void> onQuizSaving<T extends QuizStateRepository>({BuildContext context, int pos}) async {
    if (T == MySavedQuizStateProvider) {
      bool val = Platform.isAndroid
          ? await showDialog(context: context, useRootNavigator: true, builder: (context) => YesOrNoAlertDialog())
          : await showCupertinoDialog(context: context, useRootNavigator: true, builder: (context) => YesOrNoAlertDialog());
      if (val) {
        Provider.of<T>(context, listen: false).onMaterialSaving(pos);
      }
    } else {
      Provider.of<T>(context, listen: false).onMaterialSaving(pos);
    }
  }

  static String getFailureMessage(ContractResponse response, String materialName, bool forSaved) {
    if (response is NoInternetConnection) {
      return 'Oops!! No Internet Connection\n make sure your device is connected to the internet and try again';
    } else {
      return 'Oops!!\n\nFailed to load ${forSaved ? 'saved' : ''} $materialName\n'
          'something went wrong \nor it might be the server is not responding\n';
    }
  }

  static Future<String> showEditOrDeleteModalSheet({
    @required BuildContext context,
  }) async {
    UserInfoStateProvider userInfoState = locator<UserInfoStateProvider>();

    final _editText = 'Edit';
    final _deleteText = 'Delete';
    userInfoState.setBottomNavBarVisibilityTo(false);

    final Widget _bodyWidget = EditOrDeleteOptionWidget(
      onEditText: _editText,
      onDeleteText: _deleteText,
    );
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => _bodyWidget,
    ).whenComplete(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        userInfoState.setBottomNavBarVisibilityTo(true);
      },
    );
  }

  static Future<String> showBioModalSheet({@required BuildContext context, forEdit = false}) async {
    UserInfoStateProvider userInfoState = locator<UserInfoStateProvider>();
    userInfoState.setBottomNavBarVisibilityTo(false);
    return await showModalBottomSheet(
      context: context,
      builder: (_) => BioOptionsWidget(forEdit),
      backgroundColor: Colors.transparent,
    ).whenComplete(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        userInfoState.setBottomNavBarVisibilityTo(true);
      },
    );
  }

  /// [return the following values] <br>
  /// [view ==> for viewing picture ]<br>
  /// [delete ===> for deleting picture]<br>
  /// [camera ===> for uploading from camera]<br>
  /// [gallery ===> for uploading form gallery]<br>
  static Future<String> showProfilePicturesModalSheet({
    @required BuildContext context,
    @required String pictureName,
    bool enableDelete = false,
  }) async {
    UserInfoStateProvider userInfoState = locator<UserInfoStateProvider>();
    final _editText = 'Upload new $pictureName Picture';
    final _deleteText = 'Delete $pictureName picture';
    final _viewText = 'View $pictureName picture';
    userInfoState.setBottomNavBarVisibilityTo(false);

    final Widget _bodyWidget = ProfilePicturesModalSheet(
      onEditText: _editText,
      onDeleteText: _deleteText,
      onViewText: _viewText,
      deleteEnabled: enableDelete,
    );
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => _bodyWidget,
      isScrollControlled: true,
    ).whenComplete(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        userInfoState.setBottomNavBarVisibilityTo(true);
      },
    );
  }

  static Future<String> uploadPDFToCloud(File pdf) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String pdfName = 'pdf_' + DateTime.now().millisecondsSinceEpoch.toString();
    StorageTaskSnapshot snapshot = await storage.ref().child('school_pdfs/$pdfName.pdf').putFile(pdf).onComplete.catchError((err) {
      print('error');
      print(err);
      print('error');
    });
    print(snapshot.ref.getDownloadURL());
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl == null || downloadUrl.isEmpty ? null : downloadUrl;
  }
}
