import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';

class QuizDraftState with ChangeNotifier {
  List<Map<String, dynamic>> _quizDrafts = [];

  List<Map<String, dynamic>> get quizDrafts => _quizDrafts;

  Future<void> loadQuizDrafts() async {
    print('loading drafts');
    var results = await QuizAccessObject().fetchAllDrafts();
    print('loading ended');
    updateQuizDrafts(results);
  }

  void updateQuizDrafts(List<Map<String, dynamic>> update) {
    _quizDrafts = update;
    notifyListeners();
  }

  Future<void> deleteQuizDraft(int index,int pos) async {
    print(index);
    await QuizAccessObject().clearDraft(index: index);
    // this to update the number of collections of drafts appears in the profile page
    locator<DialogService>().profilePageState.updateQuizDraftsCount();
    if(quizDrafts.length == 1){
      _quizDrafts.clear();
      _quizDrafts.add({'empty':true});

    }else{
      _quizDrafts.removeAt(pos);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    print('Quiz drafts state provider has been disposed successfully');
    super.dispose();
  }
}
