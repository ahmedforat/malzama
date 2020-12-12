import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/Navigator/routes_names.dart';
import '../../../../state_provider/user_info_provider.dart';

class CollegeQuizHoldingWidget<T extends QuizStateRepository> extends StatelessWidget {
  final int pos;
  final bool fromLocal;

  CollegeQuizHoldingWidget({
    @required this.pos,
    bool fromLocal,
  }) : this.fromLocal = fromLocal ?? false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    T quizStateProvider = Provider.of<T>(context, listen: false);
    return InkWell(
      onTap: () {
        Map<String, dynamic> args = {
          'data': quizStateProvider.materials[pos],
          'fromLocal': fromLocal,
        };
        Navigator.of(context).pushNamed(RouteNames.TAKE_QUIZ_EXAM, arguments: args);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderWidget<T>(pos),
              _DescriptionWidget<T>(pos),
              _FooterWidget<T>(pos),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionWidget<T extends QuizStateRepository> extends StatelessWidget {
  final int pos;

  const _DescriptionWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setSp(40),
        left: ScreenUtil().setSp(30),
      ),
      child: Selector<T, String>(
        selector: (_, QuizStateRepository stateProvider) => stateProvider.materials[pos].credentials.description,
        builder: (_, description, __) => Text(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
          ),
        ),
      ),
    );
  }
}

class _HeaderWidget<T extends QuizStateRepository> extends StatelessWidget {
  final int pos;

  const _HeaderWidget(this.pos, {bool fromLocal});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    T quizStateProvider = Provider.of<T>(context, listen: false);

    UserInfoStateProvider userInfoState = Provider.of<UserInfoStateProvider>(context, listen: false);
    final bool isMyQuiz = userInfoState.userData.id == quizStateProvider.materials[pos].author.id;

    void _onEditOption(BuildContext context) async {
      print('just beofore Navigation to edit quiz');
      await Future.delayed(Duration(milliseconds: 230));
      Navigator.of(context).pushNamed(
        RouteNames.EDIT_UPLOADED_QUIZ,
        arguments: quizStateProvider.materials[pos],
      );
    }

    void _onDeleteOption(BuildContext context) async {
      print('Deleting');
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(10),
                  left: ScreenUtil().setSp(60),
                ),
                child: Selector<T, int>(
                  selector: (context, QuizStateRepository stateProvider) => stateProvider.materials[pos].questionsCount,
                  builder: (_, count, __) => Text(
                    '$count questions',
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                  ),
                ),
              ),
              if (isMyQuiz)
                FlatButton(
                  onPressed: () async {
                    final String action = await HelperFucntions.showEditOrDeleteModalSheet(
                      context: context,
                    );
                    if (action == null) {
                      print('the action is $action');
                      return;
                    }
                    if (action == 'edit') {
                      _onEditOption(context);
                    }
                    _onDeleteOption(context);
                  },
                  child: Icon(Icons.edit),
                ),
              if (!isMyQuiz)
                FlatButton(
                  onPressed: () => HelperFucntions.onQuizSaving<T>(context: context, pos: pos),
                  child: Selector<T, bool>(
                    selector: (context, QuizStateRepository stateProvider) => stateProvider.materials[pos].isSaved,
                    builder: (_, isSaved, __) => Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(30),
              left: ScreenUtil().setSp(30),
            ),
            child: Selector<T, String>(
              selector: (BuildContext context, QuizStateRepository stateProvider) => stateProvider.materials[pos].credentials.title,
              builder: (_, title, __) => Text(
                title ?? 'Unavailable',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(15),
              left: ScreenUtil().setSp(80),
            ),
            child: Text('Published in: ' + quizStateProvider.materials[pos].postDate.substring(0, 10).toString()),
          ),
          if (quizStateProvider.materials[pos].lastUpdate != null)
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setSp(6),
                left: ScreenUtil().setSp(80),
              ),
              child: Selector<T, String>(
                selector: (_, QuizStateRepository stateProvider) => stateProvider.materials[pos].lastUpdate,
                builder: (_, lastUpdate, __) => Text('Last update: ${lastUpdate.substring(0, 10)}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _FooterWidget<T extends QuizStateRepository> extends StatelessWidget {
  final int pos;

  const _FooterWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizStateRepository quizStateProvider = Provider.of<T>(context, listen: false);
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Selector<T, List<String>>(
                selector: (_, QuizStateRepository stateProvider) => [
                  stateProvider.materials[pos].author.firstName,
                  stateProvider.materials[pos].author.lastName,
                ],
                builder: (_, data, __) => Text(
                  data.first + ' ' + data.last,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(5),
                  left: ScreenUtil().setSp(30),
                ),
                child: Selector<T, List<String>>(
                  selector: (_, QuizStateRepository stateProvider) => [
                    stateProvider.materials[pos].author.college,
                    stateProvider.materials[pos].author.university,
                  ],
                  builder: (_, data, __) => Text(
                    data.first + ' \n ' + data.last,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stage ' + quizStateProvider.materials[pos].credentials.stage),
              if (quizStateProvider.materials[pos].credentials.semester != 'unknown')
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
              if (quizStateProvider.materials[pos].credentials.semester != 'unknown')
                Selector<T, String>(
                    selector: (_, QuizStateRepository stateProvider) => stateProvider.materials[pos].credentials.semester,
                    builder: (_, semester, __) => Text('Semester $semester'))
            ],
          )
        ],
      ),
    );
  }
}
