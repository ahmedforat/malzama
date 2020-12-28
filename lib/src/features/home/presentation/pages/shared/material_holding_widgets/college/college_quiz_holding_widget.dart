import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/api/api_client/clients/common_materials_client.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/quiz_access_object.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_service.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
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
              Divider(),
              _Footer<T>(pos: pos),
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
      locator<DialogService>().showDialogOfLoading(message: 'deleting ....');
      final String id = quizStateProvider.materials[pos].id;
      final String collectionName = quizStateProvider.isAcademic ? 'uniquizes' : 'schquizes';

      ContractResponse response = await CommonMaterialClient().deleteMaterial(
        materialId: id,
        collectionName: collectionName,
      );
      print(response.runtimeType);
      if (response is Success) {
        print('inside success of response');
        print(response.runtimeType);
        quizStateProvider.removeMaterialAt(pos);
        await QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES, id: id);
        locator<DialogService>().completeAndCloseDialog(null);
        quizStateProvider.showSnackBar('Done, collection is deleted', seconds: 4);
      } else {
        locator<DialogService>().completeAndCloseDialog(null);
        quizStateProvider.showSnackBar('Failed to delete', seconds: 4);
      }
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
                      return;
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

class _Footer<B extends QuizStateRepository> extends StatelessWidget {
  final int pos;

  const _Footer({@required this.pos});

  @override
  Widget build(BuildContext context) {
    final String semester = Provider.of<B>(context, listen: false).materials[pos].credentials.semester.toString();

    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Selector<B, List<String>>(
                    selector: (context, stateProvider) => [
                          stateProvider.materials[pos].author.firstName,
                          stateProvider.materials[pos].author.lastName,
                        ],
                    builder: (context, names, _) {
                      String text = names.first + ' ' + names.last + ' abdulKareem alsudanie';
                      final int endIndex = text.length >= 40 ? 40 : text.length;
                      text = text.substring(0, endIndex);
                      return Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                Selector<B, List<String>>(
                  selector: (context, stateProvider) => [
                    stateProvider.materials[pos].author.college,
                    stateProvider.materials[pos].author.university,
                  ],
                  builder: (context, names, _) {
                    String text = names.first + ' / ' + names.last;
                    final int endIndex = text.length >= 40 ? 40 : text.length;
                    text = text.substring(0, endIndex);
                    return Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              color: Colors.grey,
              width: ScreenUtil().setWidth(1),
            ),
            Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setSp(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Selector<B, String>(
                    selector: (context, stateProvider) => stateProvider.materials[pos].credentials.stage,
                    builder: (context, stage, _) => Text(
                      'Stage $stage',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (semester != 'unknown')
                    Selector<B, String>(
                      selector: (context, stateProvider) => stateProvider.materials[pos].credentials.semester,
                      builder: (context, semester, _) => Text(
                        'Semester $semester',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
