import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_collection_model.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:sembast/sembast.dart';

import '../app_database.dart';

class MyUploaded {
  static const QUIZES = 'my-uploaded-quizes';
  static const LECTURES = 'my-uploaded-lectures';
  static const VIDEOS = 'my-uploaded-videos';
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
  Future<bool> saveQuizItemsToDrafts(String id, List<QuizEntity> entities, QuizCredentials credentials) async {
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

      Map<String, dynamic> payload = {
        'index': index,
        'questions': entities.map((e) => e.toJSON()).toList(),
        '_id': id,
      }..addAll(credentials.toJSON());

      ref.add(await this.database, payload);
      print('saving done');

      // end the process and return true
      return true;
    }
    // all the stores are full
    return false;
  }

  // fetch quiz with the specific index from drafts
  Future<QuizDraftEntity> fetchQuizListFromDrafts(int index) async {
    var results = await intMapStoreFactory.store(draftStores[index]).find(await this.database);
    print(results);
    if (results.length == 0) {
      // no items
      return null;
    }
    return QuizDraftEntity.fromJSON(results[0].value);
  }

  // fetch all quiz drafts
  Future<List<QuizDraftEntity>> fetchAllDrafts() async {
    print('inside fetching all Drafts 000');

    await _initializeAvailableStoresIndexes();

    List<QuizDraftEntity> drafts = [];

    print('available stores == $_availableStoresIndexes');
    if (_availableStoresIndexes.length == 10) {
      // all the available stores are empty
      // this means that there are no quiz collection saved in the drafts
      return drafts;
    }

    for (int i = 0; i < 10; i++) {
      if (!_availableStoresIndexes.contains(i)) {
        var results = await intMapStoreFactory.store(draftStores[i]).find(await this.database);
        print('before the first for loop of the fetch all');
        if (results != null && results.isNotEmpty) {
          print(results[0].value);
          drafts.add(new QuizDraftEntity.fromJSON(results[0].value));
        }
      }
    }
    return drafts;
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
    locator<UserInfoStateProvider>().updateQuizDraftsCount();
  }

  Future clearAllDrafts() async {
    for (String ref in draftStores) {
      await intMapStoreFactory.store(ref).delete(await this.database);
    }
    List<int> myList = List<int>.generate(10, (i) => i);
    await store.record(_AVAILABLE_STORES_INDEXES).put(await this.database, myList);
    //locator<DialogService>().profilePageState.updateQuizDraftsCount();
  }

  Future<bool> hasAvailableStores() async {
    await _initializeAvailableStoresIndexes();
    return _availableStoresIndexes.length > 0;
  }

  Future getAvailableStores() async {
    print('this is the available stores');
    return await store.record(_AVAILABLE_STORES_INDEXES).get(await this.database);
  }

  // get uploaded materials
  Future<List<Map<String, dynamic>>> getUploadedMaterials(String storeName) async {
    Map<String, dynamic> myDataAsAuthor = await HelperFucntions.getAuthorPopulatedData();
    var res = await intMapStoreFactory.store(storeName).find(await this.database);
    List<Map<String, dynamic>> payload = res.map<Map<String, dynamic>>((item) {
      Map<String, dynamic> newItem = {...item.value};
      if (newItem['author'].runtimeType.toString() == 'String') {
        newItem['author'] = myDataAsAuthor;
      }
      return newItem;
    }).toList();

    return payload ?? <Map<String, dynamic>>[];
  }

  // get single uploaded material by id
  Future<QuizCollection> getUploadedQuizById(String storeName, String id) async {
    var res = await intMapStoreFactory.store(storeName).findFirst(
          await this.database,
          finder: Finder(
            filter: Filter.equals('_id', id),
          ),
        );
    if (res != null) {
      Map<String, dynamic> record = {...res.value};
      if (record != null && record['author'].runtimeType.toString() == 'String') {
        record['author'] = await HelperFucntions.getAuthorPopulatedData();
      }
      return record == null ? null : new QuizCollection.fromJSON(record);
    } else {
      return null;
    }
  }

  Future<StudyMaterial> getUploadedVideoOrPdfById({@required String storeName, @required String id}) async {
    var res = await intMapStoreFactory.store(storeName).findFirst(
          await this.database,
          finder: Finder(
            filter: Filter.equals('_id', id),
          ),
        );
    if (res != null) {
      Map<String, dynamic> record = {...res.value};
      if (record != null && record['author'].runtimeType.toString() == 'String') {
        record['author'] = await HelperFucntions.getAuthorPopulatedData();
      }
      print('record == $record');
      return record == null ? null : new StudyMaterial.fromJSON(record);
    }
    return null;
  }

  Future<bool> findOneAndUpdateById({@required String id, @required Map<String, dynamic> value, @required String storeName}) async {
    try {
      await intMapStoreFactory.store(storeName).update(
            await this.database,
            value,
            finder: Finder(
              filter: Filter.equals('_id', id),
            ),
          );
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> saveUploadedMaterial(String storeName, Map<String, dynamic> payload) async {
    try {
      await intMapStoreFactory.store(storeName).add(
            await this.database,
            payload,
          );
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> deleteUploadedMaterial(String name, {String id}) async {
    try {
      if (id != null) {
        await intMapStoreFactory.store(name).delete(await this.database, finder: Finder(filter: Filter.equals('_id', id)));
      } else {
        await intMapStoreFactory.store(name).delete(await this.database);
      }
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }
}
