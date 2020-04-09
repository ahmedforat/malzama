import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileSystemServices {
  static Future<bool> saveUserData(Map data) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/userData.txt');
      file.writeAsStringSync(json.encode(data));
      return true;
    } catch (err) {
      return false;
    }
  }

  static Future<dynamic> getUserData() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/userData.txt');
      String data = await file.readAsString();
      if (data == null || data.isEmpty) return null;
      return json.decode(data);
    } catch (err) {
      return false;
    }
  }

  static Future<bool> deleteUserData() async{
     try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/userData.txt');
      file.writeAsStringSync('');
      return true;
    } catch (err) {
      return false;
    }
  }

}
