import 'package:flutter/foundation.dart';

import '../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../../../../core/platform/services/dialog_services/service_locator.dart';
import '../pages/my_materials/materialPage/quizes/quiz_draft_model.dart';
import 'user_info_provider.dart';

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
      notifyMyListeners();
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
    print(results.length);
    print('refreshing');
    notifyMyListeners();
  }
  void updateQuizDrafts(List<QuizDraftEntity> update) {
    _quizDrafts = update;
    notifyMyListeners();
  }

  Future<void> deleteQuizDraft(int index,int pos) async {
    print(index);
    await QuizAccessObject().removeDrftAt(index: index);
    // this to update the number of collections of drafts appears in the profile page
    locator<UserInfoStateProvider>().updateQuizDraftsCount();
    _quizDrafts.removeAt(pos);
    notifyMyListeners();
  }

  bool _isDisposed = false;
void notifyMyListeners(){
  if(!_isDisposed){
    notifyListeners();
  }
}
  @override
  void dispose() {
    _isDisposed = true;
    print('Quiz drafts state provider has been disposed successfully');
    super.dispose();
  }
}
