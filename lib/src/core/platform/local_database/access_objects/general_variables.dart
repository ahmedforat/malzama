import 'package:malzama/src/core/platform/local_database/app_database.dart';
import 'package:sembast/sembast.dart';

class GeneralVariablesKeys {
  static const String SHOW_ME_QUIZ_INSTRUCTIONAL_MESSAGE = 'show_me_quiz_instructional_message';
}

class GeneralVariablesService {
  static StoreRef _store = StoreRef.main();

  static Future<Database> get _database async => await LocalDatabase.getInstance().database;

  static Future<void> setQuizWelcomeMessagePermissionTo(bool update) async {
    _store.record(GeneralVariablesKeys.SHOW_ME_QUIZ_INSTRUCTIONAL_MESSAGE).put(await _database, update);
  }

  static Future<bool> get getQuizWelcomeMessagePermission async =>
      await _store.record(GeneralVariablesKeys.SHOW_ME_QUIZ_INSTRUCTIONAL_MESSAGE).get(await _database);
}
