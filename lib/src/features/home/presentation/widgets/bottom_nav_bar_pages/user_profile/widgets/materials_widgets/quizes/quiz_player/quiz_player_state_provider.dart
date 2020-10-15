import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/features/home/models/material_author.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_collection_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';

class QuizPlayerOption {
  String text;
  bool isSelected;

  QuizPlayerOption({@required this.text, this.isSelected = false});
}

class PlayerQuizEntity extends QuizEntity {
  bool finalResult;
  List<int> proposedAnswers = [];
  List<QuizPlayerOption> playerOptions;

  PlayerQuizEntity.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {
    this.playerOptions = this.options.map<QuizPlayerOption>((option) => new QuizPlayerOption(text: option)).toList();
  }

  bool checkAnswer() {
    proposedAnswers.sort();
    answers.sort();
    finalResult = proposedAnswers.join('') == answers.join('');
    return finalResult;
  }
}

class QuizPlayerStateProvider with ChangeNotifier {
  // ==================================================================
  // Scaffold Key
  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // ==================================================================

  // Snack bar indicator
  bool _isSnackBarVisible = false;

  bool get isSnackBarVisible => _isSnackBarVisible;

  // ==================================================================
  // is Fetching
  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    if (update != null) {
      _isFetching = update;
      notifyListeners();
    }
  }

  // ==================================================================

  // ==================================================================
  // is Fetching
  bool _hasStartedTheQuiz = false;

  bool get hasStartedTheQuiz => _hasStartedTheQuiz;

  void setHasStartedTheQuizTo(bool update) {
    if (update != null) {
      _hasStartedTheQuiz = update;
      notifyListeners();
    }
  }

  // ==================================================================
  //
  //
  //
  //
  //
  //

  String _quizID;

  String get quizID => _quizID;

  // quiz author
  MaterialAuthor _author;

  MaterialAuthor get author => _author;

  // ==================================================================

  // quiz credentials
  QuizCredentials _credentials;

  QuizCredentials get credentials => _credentials;

  // ==================================================================
  //
  //
  //
  //
  //
  //
  // ==================================================================

  // quiz items
  List<PlayerQuizEntity> _quizItems = [];

  List<PlayerQuizEntity> get quizItems => _quizItems;

  // ==================================================================

  // ==================================================================
  // Correct Proposed Answers
  int _correctProposedAnswers = 0;

  int get correctProposedAnswers => _correctProposedAnswers;

  void incrementCorrectProposedAnswers() {
    _correctProposedAnswers += 1;
    notifyListeners();
  }

  // ==================================================================

  // ==================================================================
  // Correct Proposed Answers
  int _inCorrectProposedAnswers = 0;

  int get inCorrectProposedAnswers => _inCorrectProposedAnswers;

  void incrementInCorrectProposedAnswers() {
    _inCorrectProposedAnswers += 1;
    notifyListeners();
  }

  // ==================================================================

  //
  //
  //
  //
  //
  // ==================================================================
  // page and scroll controllers

  PageController _pageController;
  ScrollController _scrollController;

  PageController get pageController => _pageController;

  ScrollController get scrollController => _scrollController;

  // ==================================================================

  QuizCollection _quizCollection;

  QuizCollection get quizCollection => _quizCollection;

  // ==================================================================

  // Constructor
  QuizPlayerStateProvider(QuizCollection payload) {
    print('=================================================');
    print('initial satate of quiz player');
    print(payload.toJSON());

    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _quizCollection = payload;

    _credentials = payload.credentials;
    _author = payload.author;
    _quizItems = payload.quizItems;
    _quizID = payload.id;
    fetchQuestions();
    _pageController = new PageController();
    _scrollController = new ScrollController();
  }

  int _currentPageIndex;

  int get currentPageIndex => _currentPageIndex;

  // this method get called when the user check in or check off one of the quiz options
  // while trying to give answers
  void updateSelectedOption(int questionPos, int optionPos, bool update) {
    if (update) {
      _quizItems[questionPos].proposedAnswers.add(optionPos);
    } else {
      _quizItems[questionPos].proposedAnswers.removeWhere((proposedOption) => proposedOption == optionPos);
    }
    _quizItems[questionPos].playerOptions[optionPos].isSelected = update;
    notifyListeners();
  }

  Future<void> fetchQuestions() async {
    print('fetching');
    if (_quizItems.length == _quizCollection.questionsCount) {
      print('ending fetching');
      return;
    }

    if (_quizItems.length == 0) {
      setIsFetchingTo(true);
    }
    print('==================================');
    print('before fetching');
    print(_quizCollection.toJSON());
    print('==================================');
    final queryString = '?skipCount=${_quizItems.length}&quizId=${_quizID}';
    print('queryString  == $queryString');
    final String url = Api.FETCH_QUIZES_QUESTIONS + queryString;
    print('full url  == $url');
    ContractResponse contractResponse = await HttpMethods.get(url: url);
    var responseBody = json.decode(contractResponse.message);
    print('==================================');
    print('after fetching');
    print(responseBody);
    print('==================================');
    List<PlayerQuizEntity> fetchedQuestions =
        responseBody['data']['questions'].map<PlayerQuizEntity>((item) => new PlayerQuizEntity.fromJSON(item)).toList();
    _quizItems.addAll(fetchedQuestions);
    setIsFetchingTo(false);
  }

  void reset() {
    _correctProposedAnswers = 0;
    _inCorrectProposedAnswers = 0;
    _quizItems.forEach((element) {
      element.finalResult = null;
      element.playerOptions.forEach((option) => option.isSelected = false);
      element.proposedAnswers = [];
    });
    pageController.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyListeners();
  }

  void headToQuizOffset() {
    _scrollController
        .animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 250), curve: Curves.easeInOut)
        .then((_) {
      if (!_hasStartedTheQuiz) {
        setHasStartedTheQuizTo(true);
      }
    });
  }

  // to check whther the answer(s) is/are matched with the actual ones
  void checkAnswer(int pos) {
    print(_quizItems[pos].proposedAnswers);
    if (_quizItems[pos].proposedAnswers.isEmpty) {
      if (!isSnackBarVisible) {
        _isSnackBarVisible = true;
        final SnackBar snackBar = new SnackBar(
          content: Text('You did not provide any answer'),
          duration: Duration(seconds: 4),
        );
        scaffoldKey.currentState.showSnackBar(snackBar).closed.then((value) => _isSnackBarVisible = false);
      }
    } else {
      if (_quizItems[pos].checkAnswer()) {
        incrementCorrectProposedAnswers();
      } else {
        incrementInCorrectProposedAnswers();
      }
    }
  }

  @override
  void dispose() {
    print('Quiz Player State Provider has been disposed');
    super.dispose();
  }
}
