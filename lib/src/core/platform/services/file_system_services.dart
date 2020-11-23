import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemServices {
  static Future<bool> saveUserData(Map<String, dynamic> data) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/userData.txt');
      file.writeAsStringSync(json.encode(data));
      return true;
    } catch (err) {
      return false;
    }
  }

  static Future<User> getUserData() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/userData.txt');
      String data = await file.readAsString();
      if (data == null || data.isEmpty) return null;
      var dataMap = json.decode(data);
      return References.specifyAccountType(dataMap);
    } catch (err) {
      return null;
    }
  }

  static Future<bool> deleteUserData() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = new File(directory.path + '/userData.txt');
      file.writeAsStringSync('');
      return true;
    } catch (err) {
      return false;
    }
  }

  /// [ this method save a file to temporary directory folder and return true.] <br>
  /// [ if failure occured somewhere during the process , it will return false]
  Future<bool> cacheFileToLocalStorage({@required File file, @required String id}) async {
    try {
      Directory supportdir = await getTemporaryDirectory();
      final String fileExtension = getFileExtenstion(file.path);
      final String fileName = '${supportdir.path}/$id.$fileExtension';
      File newFile = new File(fileName);
      newFile.writeAsStringSync(file.readAsStringSync());
      return true;
    } catch (err) {
      return false;
    }
  }

  /// [ this method returns local file path if file already exist ] <br>
  /// [otherwise it will return null]
  Future<String> isFileCached({@required String id, @required String fileCloudPath}) async {
    Directory supportdir = await getTemporaryDirectory();
    final String fileExtension = getFileExtenstion(fileCloudPath);
    final String filePath = '${supportdir.path}/$id.$fileExtension';
    return await File(filePath).exists() ? filePath : null;
  }

  /// return the file extension
  String getFileExtenstion(String filePath) {
    return filePath.split(',').last;
  }

}
