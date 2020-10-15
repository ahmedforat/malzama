import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:sembast/sembast.dart';

import '../app_database.dart';

class MyUploadedMaterialStores {
  static const MY_UPLOADED_QUIZES = 'my-uploaded-quizes';
  static const MY_UPLOADED_LECTURES = 'my-uploaded-lectures';
  static const MY_UPLOADED_VIDEOS = 'my-uploaded-videos';
}

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

  static const String _AVAILABLE_STORES_INDEXES = 'available_stores_indexes';

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

  /// initialize the list of available stores indexes method which will be called inside the constructor
  /// it will either fetch the available ones if any or create a new list (which means the stores are empty)
  Future<void> _initializeAvailableStoresIndexes() async {
    print('inside initialization of available stores indexes');

    /// try to fetch the available stores indexes (if any)
    var results = await store.record(_AVAILABLE_STORES_INDEXES).get(await this.database);

    if (results != null) {
      // the stores already exists
      _availableStoresIndexes = results.map<int>((item) => item as int).toList();
      if (_availableStoresIndexes != null && _availableStoresIndexes.length > 0) {
        _availableStoresIndexes.removeWhere((item) => item == null);
      }
    } else {
      print('inside initialization of new store indexes');
      _availableStoresIndexes = List<int>.generate(10, (i) => i);
    }
  }

  // database instance getter
  Future<Database> get database async => await LocalDatabase.getInstance().database;

  // save new collection to he local sembast database
  // it will return true when there are available stores to hold the new drafts
  // otherwise it will return false which indicate that there are no available spaces to hold the new drafts
  Future<bool> saveQuizItemsToDrafts(List<QuizEntity> entities, Map<String, dynamic> credentials) async {
    StoreRef<int, Map<String, dynamic>> ref;
    int index;
    print('first check point');

    await _initializeAvailableStoresIndexes();
    print(_availableStoresIndexes);
    print('second check point');
    if (_availableStoresIndexes.length > 0) {
      // we do have availabe stores to hold the new draft
      print(_availableStoresIndexes);
      // pick a free store from the available free stores // usually the last one
      ref = intMapStoreFactory.store(draftStores[_availableStoresIndexes.last]);

      // set the index of the newly saved draft to the index of the store that hold it
      index = _availableStoresIndexes.last;

      // remove the choosen store from the list of the available stores
      // because it has just been occupied
      _availableStoresIndexes.removeLast();
      print('available stores after saving');
      print(_availableStoresIndexes);

      // save the new available stores after removing the occupied one
      await store.record(_AVAILABLE_STORES_INDEXES).put(await this.database, _availableStoresIndexes);

      print('third check point');
      print(entities.runtimeType);

      // save the quiz entities to the jsonList
      List<Map<String, dynamic>> jsonList = entities.map((quiz) => quiz.toJSON()).toList();

      // add the credentials at the beginning of the jsonList
      jsonList.insert(0, credentials);

      // also add the index of the store that hold the newly saved draft at the beginnig as well
      jsonList.insert(0, {'index': index});

      // so far
      // the first index of the jsonList (i.e index 0) is holding the index of the store that hold this quiz collection
      // the second index of the jsonList (i.e index 1) is holding the credentials of the quiz collection like title,description ... et cetera
      // so the json list will become like this
      // jsonList = [{'index':[index]} , credentials , ... entities]
      // start inserting to the Database

      // save the new draft to the database
      await ref.addAll(await this.database, jsonList);
      print('saving done');

      // end the process and return true
      return true;
    }
    // all the stores are full
    return false;
  }

  // fetch quiz with the specific index from drafts
  Future<Map<String, dynamic>> fetchQuizListFromDrafts(int index) async {
    List<QuizEntity> quizList = [];
    var results = await intMapStoreFactory.store(draftStores[index]).find(await this.database);
    print(results);
    if (results.length == 0) {
      // no items
      return {'empty': true};
    }
    index = results[0].value['index'];
    Map<String, dynamic> credentials = results[1].value;

    for (int i = 2; i < results.length; i++) {
      quizList.add(new QuizEntity.fromJSON(results[i].value));
    }
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
      // all the available stores are empty
      // this means that there are no quiz collection saved in the drafts
      return payload;
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
    return payload;
  }

  // to check whether there are saved drafts or not
  Future<bool> hasDrafts() async {
    var results = await store.record(_AVAILABLE_STORES_INDEXES).get(await this.database);
    return results.length < 10;
  }

  Future<void> removeDrftAt({int index}) async {
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
    for (String ref in draftStores) {
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

  // savae quizes uploaded
  Future saveUploadedQuiz(Map<String, dynamic> payload) async {
    await intMapStoreFactory.store(MyUploadedMaterialStores.MY_UPLOADED_QUIZES).add(
          await this.database,
          payload,
        );
  }

  // savae lectures uploaded
  Future saveUploadedLecture(Map<String, dynamic> payload) async {
    await intMapStoreFactory.store(MyUploadedMaterialStores.MY_UPLOADED_LECTURES).add(
          await this.database,
          payload,
        );
  }

  // savae videos uploaded
  Future saveUploadedVideo(Map<String, dynamic> payload) async {
    await intMapStoreFactory.store(MyUploadedMaterialStores.MY_UPLOADED_VIDEOS).add(
          await this.database,
          payload,
        );
  }


  // get uploaded materials
  Future<List<Map<String,dynamic>>> getUploadedMaterials(String storeName)async{
    var res = await intMapStoreFactory.store(storeName).find(await this.database);
    List<Map<String,dynamic>> payload =  res.map((item) => item.value).toList();
    return payload ?? <Map<String,dynamic>>[];
  }
}
