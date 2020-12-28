import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:path_provider/path_provider.dart';

import 'dialog_services/service_locator.dart';

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
      file.deleteSync();
      return true;
    } catch (err) {
      return false;
    }
  }

  /// [ this method save a file to temporary directory folder and return true.] <br>
  /// [ if failure occured somewhere during the process , it will return false]
  static Future<String> cacheFileToLocalStorage({@required List<int> bytes, @required String id, @required String ext}) async {
    if (locator<UserInfoStateProvider>().cachedFiles.length == 15) {
      File(locator<UserInfoStateProvider>().cachedFiles.first).deleteSync();
      locator<UserInfoStateProvider>().cachedFiles.removeAt(0);
    }
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      final String cachDirPath = '${dir.path}/cached_files';
      Directory(cachDirPath).createSync();
      final String filePath = '$cachDirPath/$id.$ext';

      File newFile = new File(filePath);
      newFile.writeAsBytesSync(bytes);
      locator<UserInfoStateProvider>().cachedFiles.add(filePath);
      print('======================================');
      print('path after caching done  === $filePath');
      print('======================================');
      return filePath;
    } catch (err) {
      print('======================================');
      print('قبل لتخرب بثواني');
      print('======================================');
      throw err;
      return null;
    }
  }

  /// [ this method returns local file path if file already exist ] <br>
  /// [otherwise it will return null]
  static Future<String> isFileCached({@required String id, @required String ext}) async {
    Directory dir = await getApplicationDocumentsDirectory();
    final String filePath = dir.path + '/cached_files/$id.$ext';
    return locator<UserInfoStateProvider>().cachedFiles.contains(filePath) ? filePath : null;
  }

  static Future<bool>deleteCachedFileById(String id) async {
    try{
      final String cacheDirPath = await createCachedFilesDirectory();
      final String filePath = '$cacheDirPath/$id.pdf';
      File file = new File(filePath);
      file.deleteSync();
      locator<UserInfoStateProvider>().cachedFiles.remove(filePath);
      return true;
    }catch(err){
      print('do nothing');
      return false;
    }
  }

  static Future<String> createCachedFilesDirectory() async {
    Directory dir = await getApplicationDocumentsDirectory();
    final String cachDirPath = '${dir.path}/cached_files';
    Directory(cachDirPath).createSync();
    return cachDirPath;
  }
}
