import 'package:malzama/src/core/platform/local_database/app_database.dart';
import 'package:sembast/sembast.dart';

class MyUploadsAccessObject{
  Future<Database> get database async => await LocalDatabase.getInstance().database;




}
