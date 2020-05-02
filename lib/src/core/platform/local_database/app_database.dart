import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LocalDatabase{
  static final  LocalDatabase _instance = LocalDatabase._();
  LocalDatabase._();

  static LocalDatabase getInstance() => _instance;

 Database _database;

 Future<Database>  get database async{
   if(_database == null){
     _database = await _openDatabase();
   }
   return _database;
 }


  Future<Database> _openDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = directory.path + 'localDatabse.db';
    final Database database = await databaseFactoryIo.openDatabase(dbPath);
      return database;
  }
}