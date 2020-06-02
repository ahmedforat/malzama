import 'package:flutter/foundation.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';

class QuizStateProvider with ChangeNotifier {

  List<QuizEntity> _quizList;
  List<QuizEntity> get quizList => _quizList;
  void updateQuizList(List<QuizEntity> update){
    if(update != null){
      _quizList = update;
      notifyListeners();
    }
  }
}




