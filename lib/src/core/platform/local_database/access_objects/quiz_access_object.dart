import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:sembast/sembast.dart';

import '../app_database.dart';

class QuizAccessObject {
  StoreRef store = StoreRef.main();
  final List<String> draftStores = [
    'my_quiz_uploads_drafts',
    'my_quiz_uploads_drafts1',
    'my_quiz_uploads_drafts2',
    'my_quiz_uploads_drafts3',
    'my_quiz_uploads_drafts4',
    'my_quiz_uploads_drafts5',
    'my_quiz_uploads_drafts6',
    'my_quiz_uploads_drafts7',
    'my_quiz_uploads_drafts8',
    'my_quiz_uploads_drafts9',
  ];

  final String _AVAILABLE_STORES_INDEXES = 'available_stores_indexes';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS = 'my_quiz_uploads_drafts';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS1 = 'my_quiz_uploads_drafts1';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS2 = 'my_quiz_uploads_drafts2';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS3 = 'my_quiz_uploads_drafts3';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS4 = 'my_quiz_uploads_drafts4';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS5 = 'my_quiz_uploads_drafts5';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS6 = 'my_quiz_uploads_drafts6';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS7 = 'my_quiz_uploads_drafts7';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS8 = 'my_quiz_uploads_drafts8';
//  static const String _MY_QUIZ_UPLOADS_DRAFTS9 = 'my_quiz_uploads_drafts9';
//
//  final myQuizDrafts = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS);
//  final myQuizDrafts1 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS1);
//  final myQuizDrafts2 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS2);
//  final myQuizDrafts3 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS3);
//  final myQuizDrafts4 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS4);
//  final myQuizDrafts5 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS5);
//  final myQuizDrafts6 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS6);
//  final myQuizDrafts7 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS7);
//  final myQuizDrafts8 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS8);
//  final myQuizDrafts9 = intMapStoreFactory.store(_MY_QUIZ_UPLOADS_DRAFTS9);

  List<StoreRef<int, Map<String, dynamic>>> _refs;
  List<int> _availableStoresIndexes;

  // Constructor
  QuizAccessObject();

  // initialize the list of available stores indexes method which will be called inside the constructor
  Future<void> _initializeAvailableStoresIndexes() async {
    print('inside initialization');

    var results = await store.record(_AVAILABLE_STORES_INDEXES).get(await this.database);
    if (results != null) {
      _availableStoresIndexes = results.map<int>((item) => item as int).toList();
      if(_availableStoresIndexes != null && _availableStoresIndexes.length >0){
        _availableStoresIndexes.removeWhere((item) => item == null);
      }
    }

    if (_availableStoresIndexes == null) {
      print('inside initialization if statement');
      _availableStoresIndexes = List<int>.generate(10, (i) => i);
    }
    print('End of available stores initializations');
  }

  // database instance getter
  Future<Database> get database async => await LocalDatabase.getInstance().database;

  // save new collection to he local sembast database
  Future<bool> saveQuizItemsToDrafts(List<QuizEntity> entities, Map<String, dynamic> credentials) async {
    StoreRef<int, Map<String, dynamic>> ref;
    int index;
    print('first check point');

    await _initializeAvailableStoresIndexes();
    print(_availableStoresIndexes);
    print('second check point');
    if (_availableStoresIndexes.length > 0) {
      print(_availableStoresIndexes);
      ref = intMapStoreFactory.store(draftStores[_availableStoresIndexes.last]);
      index = _availableStoresIndexes.last;
      _availableStoresIndexes.removeLast();
      print('available stores after saving');
      print(_availableStoresIndexes);
      await store.record(_AVAILABLE_STORES_INDEXES).put(await this.database, _availableStoresIndexes);

      print('third check point');
      print(entities.runtimeType);
      List<Map<String, dynamic>> jsonList = entities.map((quiz) => quiz.toJSON()).toList();
      jsonList.insert(0, credentials);
      jsonList.insert(0, {'index': index});

      // so far
      // the first index of the jsonList (i.e index 0) is holding the index of the store that hold this quiz collection
      // the second index of the jsonList (i.e index 1) is holding the credentials of the quiz collection like title,description ... et cetera

      // start inserting to the Database
      await ref.addAll(await this.database, jsonList);
      print('saving done');

      // clear the occupied storeIndex and finish the method

      return true;
    } else {
      // all stores are full
      return false;
    }
  }

  // fetch quiz with the specific index from drafts
  Future<Map<String, dynamic>> fetchQuizListFromDrafts(int index) async {
    List<QuizEntity> quizList = [];
    var results = await intMapStoreFactory.store(draftStores[index]).find(await this.database);
    print(results);
    if (results.length == 0) {
      return {'empty': true};
    }
    index = results[0].value['index'];
    Map<String, dynamic> credentials = results[1].value;

    for (int i = 2; i < results.length; i++) {
      quizList.add(new QuizEntity.fromJSON(results[i].value));
    }
    print('credentials **********************');
    print(credentials);
    print('quiz items **********************');
    print(quizList);
    return {'index': index, 'credentials': credentials, 'quizItems': quizList};
  }

  // fetch all quiz drafts
  Future<List<Map<String, dynamic>>> fetchAllDrafts() async {
    print('inside fetching all Drafts 000');

    await _initializeAvailableStoresIndexes();

    List<Map<String, dynamic>> payload = [];
    List<QuizEntity> quizList;
    print('available stores == $_availableStoresIndexes');
    if (_availableStoresIndexes.length == 10) {
      print('we are here after equality being equal to 10');
      return payload..add({'empty': true});
    }

    for (int i = 0; i < 10; i++) {
      quizList = [];
      if (!_availableStoresIndexes.contains(i)) {
        var results = await intMapStoreFactory.store(draftStores[i]).find(await this.database);
        print('before the first for loop of the fetch all');
        print(results.map((item) => item.value));
        if (results != null && results.isNotEmpty) {
          print('we are here inside');
          for (int j = 2; j < results.length; j++) {
            quizList.add(new QuizEntity.fromJSON(results[j].value));
          }
          var credentials = results[1].value;
          payload.add({'index': results[0].value['index'], 'credentials': credentials, 'quizItems': quizList});

        }
      }
    }
    if (payload.isEmpty) {
      print('we are here');
      payload.add({'empty': false});
    }
    return payload;
  }

  // to check whether there are saved drafts or not
  Future<bool> hasDrafts() async {
    var results = await store.record(_AVAILABLE_STORES_INDEXES).get(await this.database);
    return results.length > 0;
  }

  Future<void> clearDraft({int index}) async {
    // add the the index of the store that will be cleared to the availableStoreIndexes
    await _initializeAvailableStoresIndexes();
    _availableStoresIndexes.add(index);
    // save to the database
    await store.record(_AVAILABLE_STORES_INDEXES).put(await this.database, _availableStoresIndexes);
    // perform deletion
     await intMapStoreFactory.store(draftStores[index]).delete(await this.database);

     // update the count of collections in the profile page
    locator<DialogService>().profilePageState.updateQuizDraftsCount();
  }

  Future clearAllDrafts() async {
    for (var ref in draftStores) {
      await intMapStoreFactory.store(ref).delete(await this.database);
    }
    List<int> myList = List<int>.generate(10, (i) => i);
    await store.record(_AVAILABLE_STORES_INDEXES).put(await this.database, myList);
    locator<DialogService>().profilePageState.updateQuizDraftsCount();
  }

  Future<bool> hasAvailableStores() async {
    await _initializeAvailableStoresIndexes();
    return _availableStoresIndexes.length > 0;
  }

  Future getAvailableStores() async {
    print('this is the available stores');
    return await store.record(_AVAILABLE_STORES_INDEXES).get(await this.database);
  }
}
