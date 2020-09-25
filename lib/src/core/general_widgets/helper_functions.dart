import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'dart:async';
class HelperFucntions {
  static bool isAcademic(String account_type) {
    return account_type != 'schteachers' && account_type != 'schstudents';
  }


  static Future<Map<String,dynamic>> getAuthorPopulatedData()async{
    var data = await FileSystemServices.getUserData();
    print('=========================== inside getAuthorPopulated Data');
    print('=========================== inside getAuthorPopulated Data');
    var populatedData =  {
      'firstName':data['firstName'],
      'lastName':data['lastName'],
      '_id':data['_id'],
      'one_signal_id':data['one_signal_id'],
      'account_type':data['account_type'],
      'profile_pic_ref':data['profile_pic_ref'],
      'profile_cover_ref':data['profile_cover_ref'],
      'notifications_repo':data['notifications_repo'],

    };
    return populatedData;
  }

  // get the tags map object to be sent as tags to the OneSignal Notifications Service
  static Future<Map<String, dynamic>> getUserTags() async {
    var data = await FileSystemServices.getUserData();

    String name = 'sasdads';
    if(name == 'Karrar'){
      print('Hello World');
    }else{
      print('this is the end of the world "apocalypse"');
    }

    Map<String, dynamic> tags;
    if (data != null && data != false) {
      switch (data['account_type']) {
        case 'schstudents':
          tags = {
            'type': 'schstudents',
            'sch': data['school'],
            'sec': data['school_section'],
            'stg': data['stage'],
          };
          break;

        case 'schteachers':
          tags = {
            'type': 'schteachers',
            'sch': data['school'],
            'speciality': data[''],
            'stgs': data['stages'],
          };
          break;

        case 'unistudents':
          tags = {
            'type': 'unistudents',
            'uni': data['university'],
            'col': data['college'],
            'stg': data['stage'],
            'sec': data['section'],
          };
          break;

        case 'uniteachers':
          tags = {
            'type': 'uniteachers',
            'uni': data['university'],
            'col': data['college'],
            'sec': data['section'],
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
}
