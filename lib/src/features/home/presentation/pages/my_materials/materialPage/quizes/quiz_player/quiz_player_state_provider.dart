import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/core/general_widgets/helper_utils/quiz_item_edit_modal_sheet.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_list_displayer/quiz_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/api/api_client/clients/quiz_client.dart';
import '../../../../../../../../core/api/contract_response.dart';
import '../../../../../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import '../../../../../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../models/material_author.dart';
import '../quiz_collection_model.dart';
import '../quiz_draft_model.dart';
import '../quiz_entity.dart';
import 'edit_quiz_item_state_provider.dart';

class QuizPlayerOption {
  String text;
  bool isSelected;

  QuizPlayerOption({@required this.text, this.isSelected = false});
}

class PlayerQuizEntity extends QuizEntity {
  PlayerQuizEntity();

  bool finalResult;
  List<int> proposedAnswers = [];
  List<QuizPlayerOption> playerOptions;

  PlayerQuizEntity.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {
    this.playerOptions = this.options.map<QuizPlayerOption>((option) => new QuizPlayerOption(text: option)).toList();
  }

  PlayerQuizEntity copyWith(QuizEntity entity) {
    return new PlayerQuizEntity.fromJSON(entity.toJSON());
  }

  bool checkAnswer() {
    proposedAnswers.sort();
    answers.sort();
    finalResult = proposedAnswers.join('') == answers.join('');
    return finalResult;
  }

  bool get isEmpty => finalResult == null && proposedAnswers.isEmpty && playerOptions == null;
}

class QuizPlayerStateProvider with ChangeNotifier {
  bool _isDisposed = false;

  // to indicate whether we are in a locally saved quiz or fethed remotely
  final bool fromLocal;

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
      notifyMyListeners();
    }
  }

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // ==================================================================

  // ==================================================================
  // is Fetching More (for pagination of quiz questions)
  bool _isFetchingMore = false;

  bool get isFetchingMore => _isFetchingMore;

  void setIsFetchingMoreTo(bool update) {
    if (update != null) {
      _isFetchingMore = update;
      notifyMyListeners();
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
      notifyMyListeners();
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
    notifyMyListeners();
  }

  // ==================================================================

  // ==================================================================
  // Correct Proposed Answers
  int _inCorrectProposedAnswers = 0;

  int get inCorrectProposedAnswers => _inCorrectProposedAnswers;

  void incrementInCorrectProposedAnswers() {
    _inCorrectProposedAnswers += 1;
    notifyMyListeners();
  }

  // ==================================================================
  // onPageChanged
  // if we reach the last page and there are more questions to fetch
  // we will add the last page as a loading page to indicate fetching more questions
  // and once the process done
  // we remove the loading widget and append the new fetched questions to the _quizItems
  // and rebuild the page view and reload the state

  void onPageChange(int pos) {
    if (pos == _quizItems.length - 2 && !isFetchingMore && _failureMessage == null) {
      if (!fromLocal) {
        fetchQuestions();
      }
    }
  }

  // ==================================================================
  // page and scroll controllers

  PageController _pageController;
  ScrollController _scrollController;

  PageController get pageController => _pageController;

  ScrollController get scrollController => _scrollController;

  int get currentPage => _pageController.page.toInt();

  bool get isAtLastPage => currentPage == _quizItems.length - 1;
  QuizCollection _quizCollection;

  QuizCollection get quizCollection => _quizCollection;

  // ==================================================================
  // Failure Message
  String _failureMessage;

  String get failureMessage => _failureMessage;

  void setFailureMessageTo(String update) {
    _failureMessage = update;
    notifyMyListeners();
  }

  // ==================================================================
  // has fetched the questions
  bool _hasFetchedTheInitialQuestions = false;

  bool get hasFetchedTheInitialQuestions => _hasFetchedTheInitialQuestions;

  void setHasFetchedTheInitialQuestionsTo(bool update) {
    if (update != null) {
      _hasFetchedTheInitialQuestions = update;
      notifyMyListeners();
    }
  }

  // ==================================================================

  // ==================================================================
  // has fetched the Additional questions
  bool _hasFetchedTheAdditionalQuestions = false;

  bool get hasFetchedTheAdditionalQuestions => _hasFetchedTheAdditionalQuestions;

  void setHasFetchedTheAdditionalQuestionsTo(bool update) {
    if (update != null) {
      _hasFetchedTheAdditionalQuestions = update;
      notifyMyListeners();
    }
  }

  // ==================================================================
  void initializeFields() {
    _failureMessage = null;
    _isFetching = false;
    _isFetchingMore = false;
  }

  // Constructor
  QuizPlayerStateProvider(QuizCollection payload, {bool fromLocal}) : this.fromLocal = fromLocal ?? false {
    print('=================================================');
    print('initial satate of quiz player');
    print(payload.toJSON());
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _quizCollection = payload;

    _credentials = payload.credentials;
    _author = payload.author;
    _quizItems = payload.quizItems.map((e) => new PlayerQuizEntity.fromJSON(e.toJSON())).toList();
    _quizID = payload.id;
    if (_quizItems.length == 0) {
      print('fetching new questions');
      fetchQuestions();
    } else {
      _hasFetchedTheInitialQuestions = true;
      print('we already have questions');
      print('and the proof is that the quiz items length ' + _quizItems.length.toString());
    }

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
    notifyMyListeners();
  }

  Future<void> fetchQuestions() async {
    print('fetching');

    if ((_quizItems.length == _quizCollection.questionsCount) || fromLocal) {
      _failureMessage = null;
      print('ending fetching');
      return;
    }

    if (_quizItems.length == 0) {
      _hasFetchedTheInitialQuestions = false;
      setIsFetchingTo(true);
    } else {
      if (!_quizItems.last.isEmpty) {
        print('****************************************************');
        print('appending');
        print('****************************************************');
        _quizItems.add(new PlayerQuizEntity());
      }
      _hasFetchedTheAdditionalQuestions = false;
      setIsFetchingMoreTo(true);
      await Future.delayed(Duration(seconds: 1));
    }

    final int skipCount = _quizItems.length == 0 ? 0 : _quizItems.length - 1;

    ContractResponse contractResponse = await QuizClient().fetchQuizQuestions(skipCount: skipCount, quizID: quizCollection.id);
    if (contractResponse is Success) {
      _failureMessage = null;
      var responseBody = json.decode(contractResponse.message);
      print('==================================');
      print('after fetching');
      print(responseBody['data']['questions']);
      print('==================================');
      List<PlayerQuizEntity> fetchedQuestions =
          responseBody['data']['questions'].map<PlayerQuizEntity>((item) => new PlayerQuizEntity.fromJSON(item)).toList();
      if (_quizItems.isNotEmpty && _quizItems.last.isEmpty) {
        _quizItems.removeLast();
      }
      _quizItems.addAll(fetchedQuestions);
      if (isFetching) {
        _hasFetchedTheInitialQuestions = true;
      } else {
        _hasFetchedTheAdditionalQuestions = true;
      }
    } else {
      print('failure is here');
      _failureMessage = isFetching ? 'Failed to Load quiz questions' : 'Failed to Load more questions';
      if (contractResponse is NoInternetConnection) {
        _failureMessage += '\n check your internet connection and try again';
        await Future.delayed(Duration(seconds: 3));
      }
    }
    if (isFetching) {
      setIsFetchingTo(false);
    } else {
      setIsFetchingMoreTo(false);
    }
  }

  void reset() {
    print('resetting');
    _correctProposedAnswers = 0;
    _inCorrectProposedAnswers = 0;
    _quizItems.forEach((element) {
      if (!element.isEmpty) {
        element.finalResult = null;
        element.playerOptions.forEach((option) => option.isSelected = false);
        element.proposedAnswers = [];
      }
    });
    pageController.animateToPage(0, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    notifyMyListeners();
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

  Future<void> deleteQuizItemAt(BuildContext context, int index) async {
    Navigator.of(context).pop();
    if (_quizCollection.questionsCount <= 10) {
      locator<DialogService>().showDialogOfFailure(
          message: 'You can not delete anymore questions because the minimum number of questions '
              'must be 10 at least');
      return;
    }
    locator<DialogService>().showDialogOfLoading(message: 'Deleting');
    final quizItemId = _quizItems[index].id;

    ContractResponse contractResponse;
    contractResponse = await QuizClient().deleteQuizItem(
      quizItemId: quizItemId,
      quizCollectionId: _quizID,
      questionsCount: _quizCollection.questionsCount - 1,
    );

    if (contractResponse is Success) {
      _quizItems.removeAt(index);
      _quizCollection.questionsCount -= 1;
      _quizCollection.quizItems = _quizItems;

      await QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES, id: _quizID);
      print('just before saving to local db');
      // print(_credentials.toJSON());
      print(_quizCollection.credentials.toJSON());
      await QuizAccessObject().saveUploadedMaterial(MyUploaded.QUIZES, _quizCollection.toJSON());

      notifyMyListeners();
      locator<DialogService>().completeAndCloseDialog(null);

      locator<DialogService>().showDialogOfSuccess(message: 'deleted');
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      print(contractResponse.message);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to Delete quiz question');
    }
  }

  Future<void> onQuizItemEditing(BuildContext context, int pos) async {
    UserInfoStateProvider userInfoStateProvider = locator<UserInfoStateProvider>();
    await Future.delayed(Duration(milliseconds: 240));
    userInfoStateProvider.setBottomNavBarVisibilityTo(false);
    QuizEntity entity = await showModalBottomSheet(
      context: context,
      builder: (_) => ChangeNotifierProvider<EditQuizItemStateProvider>(
        create: (context) => EditQuizItemStateProvider(
          _quizItems[pos].copy,
          _quizID,
        ),
        builder: (context, _) => EditQuizItemModalSheetWidget(),
      ),
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    if (entity == null) {
      return;
    }
    await Future.delayed(Duration(milliseconds: 200));
    userInfoStateProvider.setBottomNavBarVisibilityTo(true);
    print('inside onPOSTEditQuizItem');
    _quizItems[pos] = _quizItems[pos].copyWith(entity);
    this._quizCollection.quizItems = _quizItems.map<QuizEntity>((e) => e).toList();
    if (NavigationService.getInstance().canWePopFromQuizesNavigator) {
      QuizStateProvider quizStateProvider = Provider.of<QuizStateProvider>(context, listen: false);
      quizStateProvider.updateQuizItemInCollection(_quizID, pos, entity);
    }

    if (NavigationService.getInstance().canWePopFromMyUploads) {
      MyUploadsStateProvider uploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
      uploadsStateProvider.updateQuizItemAtCollection(_quizID, pos, entity);
    }

    notifyMyListeners();
    QuizCollection localCopy = await QuizAccessObject().getUploadedQuizById(MyUploaded.QUIZES, _quizCollection.id);
    print('before editing ${localCopy.quizItems.length}');
    localCopy.quizItems[pos] = localCopy.quizItems[pos].copyWith(entity);
    print('after editing and just before saving ${localCopy.quizItems.length}');
    await QuizAccessObject().findOneAndUpdateById(id: localCopy.id, value: localCopy.toJSON(), storeName: MyUploaded.QUIZES);

    print('local update done');
  }

  Future<void> onQuizItemDelete(BuildContext context, int pos) async {
    if (_quizCollection.questionsCount == 10) {
      final String _message = 'you can not delete any more questions\n the minimum questions count per collection is 10';
      locator<DialogService>().showDialogOfFailure(message: _message);
      return;
    }

    locator<DialogService>().showDialogOfLoading(message: 'deleting ....');
    ContractResponse response = await QuizClient().deleteQuizItem(
      questionsCount: _quizCollection.questionsCount - 1,
      quizCollectionId: _quizID,
      quizItemId: _quizItems[pos].id,
    );

    if (response is Success) {
      _quizItems.removeAt(pos);
      _quizCollection.questionsCount = _quizCollection.questionsCount - 1;
      notifyMyListeners();
      QuizCollection localCopy = await QuizAccessObject().getUploadedQuizById(MyUploaded.QUIZES, _quizCollection.id);
      if (localCopy != null) {
        localCopy.questionsCount = _quizCollection.questionsCount;
        localCopy.quizItems.removeAt(pos);
        await QuizAccessObject().findOneAndUpdateById(id: localCopy.id, value: localCopy.toJSON(), storeName: MyUploaded.QUIZES);
      }
      if (NavigationService.getInstance().canWePopFromQuizesNavigator) {
        QuizStateProvider quizStateProvider = Provider.of<QuizStateProvider>(context, listen: false);
        QuizCollection upperCollection = quizStateProvider.materials.firstWhere((element) => element.id == _quizID, orElse: () => null);
        if (upperCollection != null) {
          upperCollection.questionsCount = _quizCollection.questionsCount;
          if (upperCollection.quizItems.length - 1 >= pos) {
            upperCollection.quizItems.removeAt(pos);
          }
          quizStateProvider.notifyMyListeners();
        }
      } else {
        print('inside updating the upper uploads state Provider');
        MyUploadsStateProvider uploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
        uploadsStateProvider.fetchQuizes();
      }
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfSuccess(message: 'Question deleted');
    } else {
      locator<DialogService>().completeAndCloseDialog(null);
      locator<DialogService>().showDialogOfFailure(message: 'Failed to delete question');
    }
  }

  @override
  void dispose() {
    print('Quiz Player State Provider has been disposed');
    _pageController.dispose();
    _scrollController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
