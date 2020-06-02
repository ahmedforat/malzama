import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_initial_add_btn.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_page_view/quiz_review_page.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_stage_widget.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

import 'quiz_uploader/quiz_description_widget.dart';
import 'quiz_uploader/quiz_page_view/quiz_input_page.dart';
import 'quiz_uploader/quiz_semester_widget.dart';
import 'quiz_uploader/quiz_title_widget.dart';
import 'quiz_uploader/quiz_topic_widget.dart';

class QuizUploaderWidget extends StatefulWidget {
  bool fromDrafts = false;
  Map<String, dynamic> payload;

  QuizUploaderWidget(bool fromDrafts, {@required this.payload}) : this.fromDrafts = fromDrafts;

  @override
  _QuizUploaderWidgetState createState() => _QuizUploaderWidgetState();
}

class _QuizUploaderWidgetState extends State<QuizUploaderWidget> {
  PageController pageController;
  ScrollController scrollController;
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<FormState> _formKey;
  bool onlyOnce = true;

  TextEditingController titleController;
  TextEditingController descriptionController;

  @override
  void dispose() {
    scrollController.removeListener(_fabAppearanceListener);
    pageController.dispose();
    scrollController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController();
    descriptionController = new TextEditingController();


    _formKey = new GlobalKey<FormState>();
    scaffoldKey = new GlobalKey<ScaffoldState>();
    pageController = new PageController(viewportFraction: 0.955);
    scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    if(widget.fromDrafts){
      scrollController.addListener(_fabAppearanceListener);
    }
  }

  void _fabAppearanceListener() {
    if (scrollController.offset > scrollController.position.maxScrollExtent * 0.9) {
      locator<DialogService>().quizUploadingState.setFabVisibilityTo(true);
    } else {
      locator<DialogService>().quizUploadingState.setFabVisibilityTo(false);
    }
  }

  int currentPageIndex;
  int previousPageIndex;
  int course;

  @override
  Widget build(BuildContext context) {
    QuizUploadingState uploadingState = Provider.of<QuizUploadingState>(context, listen: false);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);

    if(widget.fromDrafts && onlyOnce){
      print(' *********************************************************************  this must be called only once');
      WidgetsBinding.instance.addPostFrameCallback((d){
        uploadingState.importFromDrafts(widget.payload);

          titleController.text = uploadingState.title;
          descriptionController.text = uploadingState.description;

        onlyOnce = false;
      });
    }

    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(),
                      //height: ScreenUtil().setHeight(1750),
                      color: Colors.grey[200],
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: ScreenUtil().setHeight(45),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(60)),
                              child: Text(
                                'New MCQs collection',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(55)),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(45),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(40)),
                                    child: FlatButton(
                                      child: Text(
                                        widget.fromDrafts ? 'Save changes to drafts' : 'save to drafts',
                                        style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(45)),
                                      ),
                                      onPressed: () async {
                                        // if the collection is not opened as an editing on an existing draft and there are no free stores
                                        if (!widget.fromDrafts && !(await QuizAccessObject().hasAvailableStores())) {
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text('Your drafts are full !!\n'
                                                'try to upload or delete some of them and try again'),
                                            duration: Duration(seconds: 5),
                                          ));
                                        } else if (!_formKey.currentState.validate()) {
                                          // do nothing
                                          print('the main credentials is required like the title and description');
                                        } else if (uploadingState.quizList.isEmpty || (uploadingState.quizList.length == 1 && uploadingState.quizList.first.isEmpty)) {
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text('there is no quiz item to save'),
                                          ));
                                        }
                                        // to clear the last quiz item if it is empty
                                        else {
                                          // all requirements are met and now we are gonna save the collection to the drafts
                                          // save to the local database

                                          // remove the last quiz item if it is not completed
                                          if (uploadingState.quizList.last.isEmpty) {
                                            uploadingState.quizList.removeLast();
                                          }

                                          // save the credentials fileds like title,description ... et cetera
                                          _formKey.currentState.save();
                                          Map<String, dynamic> credentials = uploadingState.getCredentials();

                                          // if the current collection is from an exitsting drafts
                                          // so we delete the older one and replace it with the current one
                                          if (widget.fromDrafts) {
                                            print(widget.payload);
                                            await QuizAccessObject().clearDraft(index: widget.payload['index']);
                                          }



                                          // save to the database
                                          await QuizAccessObject().saveQuizItemsToDrafts(uploadingState.quizList, credentials);
                                          locator<DialogService>().profilePageState.updateQuizDraftsCount();
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text('Quiz has been saved successfully'),
                                          ));
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(right: ScreenUtil().setSp(40)),
                                  child: FlatButton(
                                    child: Text(
                                      'Upload',
                                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(45)),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        if (uploadingState.quizList.length < 10 || (uploadingState.quizList.length == 10 && uploadingState.quizList.last.isEmpty)) {
                                          WidgetsBinding.instance.addPostFrameCallback((timer) async {
                                            await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                                            scaffoldKey.currentState.showSnackBar(SnackBar(
                                              content: Text(
                                                'You must provide at least 10 quiz questions',
                                              ),
                                              duration: Duration(seconds: 4),
                                            ));
                                          });
                                          _onQuizBelowLimitHandler(uploadingState, pageController);
                                        } else if (uploadingState.quizList.any((quiz) => !quiz.hasAnswers)) {
                                          await _onQuizHasNoAnswersHandler(uploadingState, scrollController, pageController);
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text('You must provide answer(s) !!'),
                                          ));
                                        } else {
                                          // prepare for uploading to the server

                                          // save the credentials
                                          _formKey.currentState.save();

                                          // call the uploading method to the server;
                                          ContractResponse contractResponse = await uploadingState.upload();
                                          scaffoldKey.currentState.showSnackBar(SnackBar(
                                            content: Text(contractResponse.message),
                                            duration: Duration(seconds: 3),
                                          ));
                                          if (contractResponse is Success201) {
                                            if (widget.fromDrafts){
                                              await QuizAccessObject().clearDraft(index: widget.payload[0]['index']);
                                            }
                                            await Future.delayed(Duration(seconds: 3));
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            QuizTitleWidget(controller:titleController),
                            SizedBox(
                              height: ScreenUtil().setHeight(25),
                            ),
                            QuizDescriptionWidget(controller:descriptionController),
                            SizedBox(
                              height: ScreenUtil().setHeight(65),
                            ),
                            if (_isTeacher(profilePageState)) QuizStageWidget(),
                            if (isPharmacyOrMedicine(profilePageState))
                              Container(
                                // color: Colors.blueAccent,
                                alignment: Alignment.center,
                                child: Text(
                                  'Semester',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(50)),
                                ),
                                height: ScreenUtil().setHeight(110),
                                width: ScreenUtil().setWidth(360),
                              ),
                            if (isPharmacyOrMedicine(profilePageState)) QuizSemesterWidget(),
                            if (isPharmacyOrMedicine(profilePageState))
                              SizedBox(
                                height: ScreenUtil().setHeight(50),
                              ),
                            if (profilePageState.userData.commonFields.account_type != 'schteachers') QuizTopicWidget(),
                            if (profilePageState.userData.commonFields.account_type != 'schteachers')
                              SizedBox(
                                height: ScreenUtil().setHeight(140),
                              ),
                            Container(
                              padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                              child: Text(
                                'Add questions',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(55)),
                              ),
                              alignment: Alignment.topLeft,
                              //color: Colors.amber,
                            ),
                            Padding(
                              padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                              child: Selector<QuizUploadingState, int>(
                                selector: (context, stateProvider) => stateProvider.quizList.length,
                                builder: (context, total, _) => Container(
                                  alignment: Alignment.center,
                                  child: Text('Total : $total questions'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Selector<QuizUploadingState, List>(
                      selector: (context, stateProvider) => [stateProvider.quizList, stateProvider.currentPageIndex, stateProvider.quizList.length],
                      builder: (context, _, __) => uploadingState.quizList.length == 0
                          ? InkWell(
                              onTap: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
                                });
                                scrollController.addListener(_fabAppearanceListener);
                                uploadingState.appendToQuizList(new QuizEntity());
                                print(scrollController.position.maxScrollExtent);
                              },
                              child: QuizInitialAddButton())
                          : Container(
                              color: Colors.grey,
                              height: ScreenUtil().setHeight(1600),
                              child: SizedBox.expand(
                                child: PageView.builder(
                                    controller: pageController,
                                    //scrollDirection: Axis.horizontal,
                                    itemCount: uploadingState.quizList.length,
                                    onPageChanged: (pos) {
                                      uploadingState.updateCurrentPageIndex(pos);
                                    },
                                    itemBuilder: (context, pos) {
                                      return Selector<QuizUploadingState, bool>(
                                        selector: (context, stateProvider) => stateProvider.quizList[pos].inReviewMode,
                                        builder: (context, inReviewMode, __) => AnimatedSwitcher(
                                          child: inReviewMode ? animatedQuizReviewBuilder(pos, uploadingState) : animatedQuizEditBuilder(pos, uploadingState),
                                          duration: Duration(milliseconds: 350),
                                          switchInCurve: Curves.easeInOut,
                                          switchOutCurve: Curves.bounceInOut,
                                        ),
                                      );
                                    }),
                              ),
                            ),
                    ),
                  ],
                ),
              )),
        ),
        floatingActionButton: Selector<QuizUploadingState, bool>(
          selector: (context, stateProvider) => stateProvider.isFabVisible,
          builder: (context, isFabVisible, _) => !isFabVisible
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Selector<QuizUploadingState, bool>(
                      selector: (context, stateProvider) => stateProvider.isFabVisible,
                      builder: (context, isFabVisible, _) => FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () => _onAddNewQuizItemHandler(uploadingState, scrollController, scaffoldKey, pageController),
                      ),
                    ),
                    FlatButton(
                      child: Text('clear drafts'),
                      onPressed: () async{
                       await QuizAccessObject().clearAllDrafts();
                       print('all drafts are deleted');
                      },
                    ),
                    FlatButton(
                      child: Text('drafts'),
                      onPressed: () async {
                        print(await QuizAccessObject().fetchAllDrafts());
                      },
                    ),
                    FlatButton(
                      child: Text('available stores'),
                      onPressed: () async {
                        print('this is the available stores ');
                        print(await QuizAccessObject().getAvailableStores());
                        QuizAccessObject().getAvailableStores().then((value){
                          print(value.last);
                          print(value.last == null);
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  animatedQuizEditBuilder(int pos, QuizUploadingState uploadingState) {
    return Center(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)),
          color: Colors.grey[200],
        ),
        duration: Duration(milliseconds: 500),
        child: QuizEditBuilder(
          pos: pos,
        ),
        width: ScreenUtil().setWidth(
          pos == uploadingState.currentPageIndex ? 1200 : 400,
        ),
        height: ScreenUtil().setHeight(
          pos == uploadingState.currentPageIndex ? 1500 : 400,
        ),
      ),
    );
  }

  animatedQuizReviewBuilder(int pos, QuizUploadingState uploadingState) {
    return Center(
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)),
        ),
        duration: Duration(milliseconds: 500),
        child: QuizReviewBuilder(pos: pos),
        width: ScreenUtil().setWidth(
          pos == uploadingState.currentPageIndex ? 1200 : 400,
        ),
        height: ScreenUtil().setHeight(
          pos == uploadingState.currentPageIndex ? 1500 : 400,
        ),

        //color: pos % 2 == 0 ? Colors.blueAccent : Colors.redAccent,
      ),
    );
  }
}

class TargetPage extends StatelessWidget {
  final String src;
  final Color color;
  final String tag;

  const TargetPage({Key key, @required this.color, this.tag, this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        color: color,
        child: Image.network(src, fit: BoxFit.fill),
      ),
    );
  }
}

bool isPharmacyOrMedicine(ProfilePageState profilePageState) {
  String account_type = profilePageState.userData.commonFields.account_type;
  if (account_type != 'uniteachers' && account_type != 'unistudents') {
    return false;
  }
  RegExp pharmacyPattern = new RegExp(r'صيدلة');
  RegExp dentistPattern = new RegExp(r'سنان');
  RegExp analysisPattern = new RegExp(r'مرضية');

  String college = profilePageState.userData.college;

  bool isMedicine = !dentistPattern.hasMatch(college) && !analysisPattern.hasMatch(college) && !pharmacyPattern.hasMatch(college);

  return (account_type == 'uniteachers' || account_type == 'unistudents') && (pharmacyPattern.hasMatch(college) || isMedicine);
}

bool _isTeacher(ProfilePageState profilePageState) {
  String account_type = profilePageState.userData.commonFields.account_type;
  return account_type == 'uniteachers' || account_type == 'schteachers';
}

// handler called when the list of quizes to be uploaded is less than 10
Future<void> _onQuizBelowLimitHandler(QuizUploadingState uploadingState, PageController pageController) async {
  if (uploadingState.quizList.any((quiz) => quiz.isEmpty)) {
    var targetPos = uploadingState.quizList.indexWhere((quiz) => quiz.isEmpty);
    print('this is the targetPos $targetPos');
    await pageController.animateToPage(targetPos, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  } else {
    print('inside the appending');
    uploadingState.appendToQuizList(new QuizEntity());
    var targetPos = uploadingState.quizList.indexOf(uploadingState.quizList.last);
    pageController.animateToPage(targetPos, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  }
}

// handler called when there is at least one quiz item that has no answers
Future<void> _onQuizHasNoAnswersHandler(QuizUploadingState uploadingState, ScrollController scrollController, PageController pageController) async {
  await scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
  int targetPos = uploadingState.quizList.indexOf(uploadingState.quizList.firstWhere((quiz) => !quiz.hasAnswers));
  await pageController.animateToPage(targetPos, duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
}

// this handler called when user hit the FloatingActionButton Of adding a new quiz item
void _onAddNewQuizItemHandler(QuizUploadingState uploadingState, ScrollController scrollController, GlobalKey<ScaffoldState> scaffoldKey, PageController pageController) {
  if (uploadingState.quizList.length == 0 || scrollController.offset < scrollController.position.maxScrollExtent) {
    WidgetsBinding.instance.addPostFrameCallback((timer) {
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  // make sure that the last quiz is complete with all it's fields
  // cause the add button does not add a new quiz item unless the last one is complete
  QuizEntity lastOne;
  if (uploadingState.quizList.length != 0) lastOne = uploadingState.quizList.last;
  if (lastOne.isEmpty) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Please save the current quiz item then add another one'),
    ));
  } else {
    uploadingState.appendToQuizList(new QuizEntity());
    pageController.animateToPage(uploadingState.quizList.length - 1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
