import 'package:malzama/src/core/platform/local_database/app_database.dart';
import 'package:sembast/sembast.dart';

class UserCachedInfo{
  var store = StoreRef.main();
  Future<Database> get database async => await LocalDatabase.getInstance().database;


  saveStringKey(String record,dynamic value)async{
    store.record(record).put(await database, value);
  }

  Future getRecord(String record)async{
    return await store.record(record).get(await database);
  }
}