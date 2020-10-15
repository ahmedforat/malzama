import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/general_variables.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/instructional_message.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_initial_add_btn.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader/quiz_page_view/questions_page_view.dart';
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
  QuizDraftEntity payload;

  QuizUploaderWidget(
    bool fromDrafts, {
    this.payload,
  }) : this.fromDrafts = fromDrafts;

  @override
  _QuizUploaderWidgetState createState() => _QuizUploaderWidgetState();
}

class _QuizUploaderWidgetState extends State<QuizUploaderWidget> {
  GlobalKey<FormState> _formKey;
  bool onlyOnce = true;

  TextEditingController titleController;
  TextEditingController descriptionController;

  @override
  void dispose() {
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
  }

  int currentPageIndex;
  int previousPageIndex;
  int course;

  @override
  Widget build(BuildContext context) {
    QuizUploadingState uploadingState = Provider.of<QuizUploadingState>(context, listen: false);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
    // onlyOnce to ensure that this piece of code
    //does not be called with every time the build method is called
    if (widget.fromDrafts && onlyOnce) {
      print(' *********************************************************************  this must be called only once');
      WidgetsBinding.instance.addPostFrameCallback((d) {
        print('importing');
        uploadingState.importFromDrafts(widget.payload);

        titleController.text = uploadingState.title;
        descriptionController.text = uploadingState.description;

        onlyOnce = false;
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (userInfoStateProvider.showQuizWelcomeMessage) {
        bool value = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => QuizInstructionalMessage(),
        );

        print('after navigating back');
        print(value);
        print('after navigating back');

        GeneralVariablesService.setQuizWelcomeMessagePermissionTo(!value);
        userInfoStateProvider.showQuizWelcomeMessage = !value;
      }
    });

    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Selector<QuizUploadingState, bool>(
        selector: (context, stateProvider) => stateProvider.isLoading,
        builder: (context, isLoading, _) => isLoading
            ? Container(
                child: Center(
                  child: Text('Loading ...'),
                ),
              )
            : Scaffold(
                key: uploadingState.scaffoldKey,
                body: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      controller: uploadingState.scrollController,
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
                                            style: TextStyle(
                                                color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(45)),
                                          ),
                                          onPressed: () async {
                                            // if the collection is not opened as an editing on an existing draft and there are no free stores
                                            if (!widget.fromDrafts && !(await QuizAccessObject().hasAvailableStores())) {
                                              uploadingState.showSnackBar(
                                                  text: 'Your drafts are full !!\n'
                                                      'try to upload or delete some of them and try again');
                                            } else if (!_formKey.currentState.validate()) {
                                              // do nothing
                                              print('the main credentials is required like the title and description');
                                            } else if (uploadingState.quizList.isEmpty ||
                                                (uploadingState.quizList.length == 1 && uploadingState.quizList.first.isEmpty)) {
                                              uploadingState.showSnackBar(text: 'there is no quiz item to save');
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
                                              QuizCredentials credentials = uploadingState.getCredentials();

                                              // if the current collection is from an exitsting drafts
                                              // so we delete the older one and replace it with the current one
                                              if (widget.fromDrafts) {
                                                print(widget.payload);
                                                await QuizAccessObject().removeDrftAt(index: widget.payload.storeIndex);
                                              }

                                              // save to the database
                                              await QuizAccessObject().saveQuizItemsToDrafts(uploadingState.quizList, credentials.toJSON());

                                              uploadingState.scaffoldKey.currentState.showSnackBar(
                                                SnackBar(
                                                  content: Text('Quiz has been saved successfully'),
                                                ),
                                              );
                                              profilePageState.updateQuizDraftsCount();
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: ScreenUtil().setSp(40)),
                                        child: FlatButton(
                                          child: Text(
                                            'Upload',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(45),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState.validate()) {
                                              if (uploadingState.quizList.length < 10 ||
                                                  (uploadingState.quizList.length == 10 && uploadingState.quizList.last.isEmpty)) {
                                                WidgetsBinding.instance.addPostFrameCallback((timer) async {
                                                  await uploadingState.animateToBottom();
                                                  uploadingState.showSnackBar(text: 'You must provide at least 10 quiz questions');
                                                });
                                                uploadingState.onQuizBelowLimitHandler();
                                              } else if (uploadingState.quizList.any((quiz) => !quiz.hasAnswers)) {
                                                await uploadingState.onQuizHasNoAnswersHandler();
                                                uploadingState.showSnackBar(text: 'You must provide answer(s) !!');
                                              } else {
                                                // prepare for uploading to the server

                                                // save the credentials
                                                _formKey.currentState.save();

                                                // call the uploading method to the server;

                                               await  uploadingState.upload(context);

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
                                  QuizTitleWidget(controller: titleController),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(25),
                                  ),
                                  QuizDescriptionWidget(controller: descriptionController),
                                  SizedBox(
                                    height: ScreenUtil().setHeight(65),
                                  ),
                                  if (HelperFucntions.isTeacher(profilePageState)) QuizStageWidget(),
                                  if (HelperFucntions.isPharmacyOrMedicine(profilePageState))
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
                                  if (HelperFucntions.isPharmacyOrMedicine(profilePageState)) QuizSemesterWidget<QuizUploadingState>(),
                                  if (HelperFucntions.isPharmacyOrMedicine(profilePageState))
                                    SizedBox(
                                      height: ScreenUtil().setHeight(50),
                                    ),
                                  if (profilePageState.userData.commonFields.account_type != 'schteachers') QuizTopicWidget(),
                                  if (profilePageState.userData.commonFields.account_type != 'schteachers')
                                    SizedBox(
                                      height: ScreenUtil().setHeight(80),
                                    ),
                                  Selector<QuizUploadingState, int>(
                                    selector: (context, stateProvider) => stateProvider.quizList.length,
                                    builder: (context, count, _) => count > 0
                                        ? Container(
                                            padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                                            child: Text(
                                              'questions',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(55)),
                                            ),
                                            alignment: Alignment.topLeft,
                                            //color: Colors.amber,
                                          )
                                        : Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: ScreenUtil().setSp(50),
                                            ),
                                            child: RaisedButton(
                                              onPressed: () {
                                                WidgetsBinding.instance.addPostFrameCallback((_) => uploadingState.animateToBottom());
                                                uploadingState.initializeFabListener();
                                                uploadingState.updateCurrentPageIndex(0);
                                                uploadingState.appendToQuizList(new QuizEntity());
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.add, size: ScreenUtil().setSp(100)),
                                                  Text(
                                                    'Add Questions',
                                                    style: TextStyle(
                                                      fontSize: ScreenUtil().setSp(50),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                                    child: Selector<QuizUploadingState, int>(
                                      selector: (context, stateProvider) => stateProvider.quizList.length,
                                      builder: (context, total, _) => total == 0
                                          ? Container()
                                          : Container(
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
                            selector: (context, stateProvider) => [
                              stateProvider.quizList,
                              stateProvider.currentPageIndex,
                              stateProvider.quizList.length,
                            ],
                            builder: (context, _, __) => uploadingState.quizList.length == 0 ? Container() : QuizQuestionsPageView(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: Selector<QuizUploadingState, bool>(
                  selector: (context, stateProvider) => stateProvider.isFabVisible,
                  builder: (context, isFabVisible, _) => !isFabVisible
                      ? Container()
                      : Selector<QuizUploadingState, bool>(
                          selector: (context, stateProvider) => stateProvider.isFabVisible,
                          builder: (context, isFabVisible, _) => FloatingActionButton(
                            child: Icon(Icons.add),
                            onPressed: () => uploadingState.onAddNewQuizItemHandler(),
                          ),
                        ),
                ),
              ),
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
