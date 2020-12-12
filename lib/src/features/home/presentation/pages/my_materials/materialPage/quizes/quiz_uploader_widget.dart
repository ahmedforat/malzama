import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_uploader/quiz_description_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_uploader/quiz_page_view/questions_page_view.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_uploader/quiz_semester_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_uploader/quiz_stage_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_uploader/quiz_title_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_uploader/quiz_topic_widget.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploader_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/platform/local_database/access_objects/general_variables.dart';
import '../../../../state_provider/user_info_provider.dart';
import 'instructional_message.dart';

class QuizUploaderWidget extends StatefulWidget {
  const QuizUploaderWidget();

  @override
  _QuizUploaderWidgetState createState() => _QuizUploaderWidgetState();
}

class _QuizUploaderWidgetState extends State<QuizUploaderWidget> {
  bool onlyOnce = true;

  int currentPageIndex;
  int previousPageIndex;
  int course;

  @override
  Widget build(BuildContext context) {
    QuizUploaderState uploadingState = Provider.of<QuizUploaderState>(context, listen: false);
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async {
        if (userInfoStateProvider.showQuizWelcomeMessage) {
          bool value = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => QuizInstructionalMessage(),
          );
          await GeneralVariablesService.setQuizWelcomeMessagePermissionTo(!value);
          userInfoStateProvider.showQuizWelcomeMessage = !value;
        }
      },
    );

    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Selector<QuizUploaderState, List<dynamic>>(
        selector: (context, stateProvider) =>
        [
          stateProvider.isLoading,
          stateProvider.failureMessage,
        ],
        builder: (context, data, _) {
          if (data.first) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if ((data.last as String) != null) {
            return Container(
              child: Center(
                child: Text(uploadingState.failureMessage),
              ),
            );
          }

          return Scaffold(
            key: uploadingState.scaffoldKey,
            body: SafeArea(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
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
                          key: uploadingState.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil().setHeight(45),
                              ),
                              _HeaderWidget(),
                              SizedBox(
                                height: ScreenUtil().setHeight(45),
                              ),
                              _SavingAndUploadingButtons(),
                              SizedBox(
                                height: ScreenUtil().setHeight(30),
                              ),
                              QuizTitleWidget(controller: uploadingState.titleController),
                              SizedBox(
                                height: ScreenUtil().setHeight(25),
                              ),
                              QuizDescriptionWidget(controller: uploadingState.descriptionController),
                              SizedBox(
                                height: ScreenUtil().setHeight(65),
                              ),
                              if (locator<UserInfoStateProvider>().isTeacher) QuizStageWidget(),
                              if (HelperFucntions.isPharmacyOrMedicine())
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
                              if (HelperFucntions.isPharmacyOrMedicine()) QuizSemesterWidget<QuizUploaderState>(),
                              if (HelperFucntions.isPharmacyOrMedicine())
                                SizedBox(
                                  height: ScreenUtil().setHeight(50),
                                ),
                              if (userInfoStateProvider.userData.accountType != 'schteachers') QuizTopicWidget(),
                              if (userInfoStateProvider.userData.accountType != 'schteachers')
                                SizedBox(
                                  height: ScreenUtil().setHeight(80),
                                ),
                              Selector<QuizUploaderState, int>(
                                selector: (context, stateProvider) => stateProvider.quizList.length,
                                builder: (context, count, _) =>
                                count > 0
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
                                child: Selector<QuizUploaderState, int>(
                                  selector: (context, stateProvider) => stateProvider.quizList.length,
                                  builder: (context, total, _) =>
                                  total == 0
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
                      Selector<QuizUploaderState, List>(
                        selector: (context, stateProvider) =>
                        [
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
            floatingActionButton: Selector<QuizUploaderState, bool>(
              selector: (context, stateProvider) => stateProvider.isFabVisible,
              builder: (context, isFabVisible, _) =>
              !isFabVisible
                  ? Container()
                  : Selector<QuizUploaderState, bool>(
                selector: (context, stateProvider) => stateProvider.isFabVisible,
                builder: (context, isFabVisible, _) =>
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed:uploadingState.onAddNewQuizItemHandler,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SavingAndUploadingButtons extends StatelessWidget {
  const _SavingAndUploadingButtons();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizUploaderState uploadingState = Provider.of<QuizUploaderState>(context, listen: false);
    return Row(
      mainAxisAlignment: uploadingState.isUpdating ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        if (!uploadingState.isUpdating)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setSp(40),
            ),
            child: FlatButton(
              child: Text(
                uploadingState.fromDrafts ? 'Save changes to drafts' : 'save to drafts',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(45),
                ),
              ),
              onPressed: () => uploadingState.saveToDraftsOnPressd(context),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setSp(40)),
          child: FlatButton(
            child: Text(
              uploadingState.fromUploaded ? 'Save and Upload' : 'Upload',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(45),
              ),
            ),
            onPressed: () => uploadingState.uplodButtonOnPressed(context),
          ),
        )
      ],
    );
  }
}

class _HeaderWidget extends StatelessWidget {

  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizUploaderState uploadingState = Provider.of<QuizUploaderState>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlatButton(
              onPressed: Navigator
                  .of(context)
                  .pop,
              child: Icon(Icons.arrow_back),
            ),
            Text(
              uploadingState.fromUploaded ? 'Edit MCQs collection' : 'New MCQs collection',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(50),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
          child: FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(40),
              ),
            ),
            onPressed: () async {
              // print(widget.payload.toJSON());
              print(uploadingState.quizCollectionID);
            },
          ),
        )
      ],
    );
  }

}


