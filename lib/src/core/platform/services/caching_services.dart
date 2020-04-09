import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CachingServices {
  static SharedPreferences _preferences;

// setting new fields
  static Future<bool> saveStringField(
      {@required String key, @required String value}) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.setString(key, value);
  }

  static Future<bool> saveStringListField(
      {@required String key, @required List<String> value}) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.setStringList(key, value);
  }

  static Future<bool> saveDoubleField(
      {@required String key, @required double value}) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.setDouble(key, value);
  }

  static Future<bool> saveBooleanField(
      {@required String key, @required bool value}) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.setBool(key, value);
  }

  static Future<bool> saveIntegerField(
      {@required String key, @required int value}) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.setInt(key, value);
  }

  static Future<void> saveMultiFields(Map<String, dynamic> fields) async {
    _preferences = await SharedPreferences.getInstance();
    for (var pair in fields.entries) {
      _preferences.setString(pair.key, pair.value.toString());
    }
  }

// getting fields

  static Future<dynamic> getField({@required String key}) async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.get(key);
  }

  static Future<Map<String, String>> getMultiFields(List<String> keys) async {
    _preferences = await SharedPreferences.getInstance();
    Map<String, String> data = {};
    for (String item in keys) {
      data[item] = await _preferences.get(item);
    }
    return data.entries.length == 0 ? null : data;
  }

  static Future<void> clearAllCachedData() async {
    _preferences = await SharedPreferences.getInstance();
    var data = _preferences.getKeys().toList();
    for (var item in data) {
      await _preferences.remove(item);
    }
  }

// contains key
  static Future<bool> containsKey({@required String key}) async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.containsKey(key);
  }

// get List of all keys
  static Future<List<String>> getAllKeys() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getKeys().toList();
  }

// remove key
  static Future<bool> removeField({@required String key}) async {
    _preferences = await SharedPreferences.getInstance();
    return await _preferences.remove(key);
  }

// clean the Cache
  static Future<bool> removeAll() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      _preferences.getKeys().toList().forEach((key)async {
        _preferences.remove(key);
      });
      return true;
    } catch (err) {
      return false;
    }
  }

  static Future<SharedPreferences> getInstance() async => await SharedPreferences.getInstance();

  static Future<bool> removeAllAndSave({@required String key,@required String value}) async {
    _preferences = await SharedPreferences.getInstance();
     try {
      _preferences = await SharedPreferences.getInstance();
      _preferences.getKeys().toList().forEach((key)async {
       await _preferences.remove(key);
      });
      _preferences.setString(key, value);
      return true;
    } catch (err) {
      return false;
    }
    
  }
}
