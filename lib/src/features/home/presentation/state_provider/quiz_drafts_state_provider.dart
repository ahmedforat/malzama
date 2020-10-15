import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';

class QuizDraftState with ChangeNotifier {

  QuizDraftState(){
    // load all the drafts
    loadQuizDrafts();
  }

  bool _isFetchingDraft = false;
  bool get isFetchingDrafts => _isFetchingDraft;

  void setIsFetchingDraftsTo(bool update){
    if(update != null){
      _isFetchingDraft = update;
      notifyListeners();
    }
  }

  List<QuizDraftEntity> _quizDrafts = [];

  List<QuizDraftEntity> get quizDrafts => _quizDrafts;

  Future<void> loadQuizDrafts() async {
    print('loading drafts');
    setIsFetchingDraftsTo(true);
    var results = await QuizAccessObject().fetchAllDrafts();
    print('loading ended');
    updateQuizDrafts(results);
    setIsFetchingDraftsTo(false);
  }

  Future<void> refresh()async{
    var results = await QuizAccessObject().fetchAllDrafts();
    updateQuizDrafts(results);
    notifyListeners();
  }
  void updateQuizDrafts(List<Map<String, dynamic>> update) {
    _quizDrafts = update.map((item) => QuizDraftEntity.fromJSON(item)).toList();
    notifyListeners();
  }

  Future<void> deleteQuizDraft(int index,int pos) async {
    print(index);
    await QuizAccessObject().removeDrftAt(index: index);
    // this to update the number of collections of drafts appears in the profile page
    locator<DialogService>().profilePageState.updateQuizDraftsCount();
    _quizDrafts.removeAt(pos);
    notifyListeners();
  }

  @override
  void dispose() {
    print('Quiz drafts state provider has been disposed successfully');
    super.dispose();
  }
}
