import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/general_widgets/helper_utils/edit_or_delete_options_widget.dart';
import '../../../../../../../../core/general_widgets/helper_utils/quiz_item_edit_modal_sheet.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../state_provider/user_info_provider.dart';
import 'edit_quiz_item_state_provider.dart';
import 'quiz_player_state_provider.dart';

class SingleQuizQuestionWidget extends StatelessWidget {
  final pos;

  SingleQuizQuestionWidget({@required this.pos});

  Color adjustOptionColor(bool finalResult, optionPos, List<int> answers, QuizPlayerStateProvider provider) {
    if (finalResult != null) {
      return answers.asMap().containsValue(optionPos)
          ? Colors.green
          : provider.quizItems[pos].playerOptions[optionPos].isSelected
              ? Colors.red
              : Colors.white;
    }
    return Colors.white;
  }

  Color adjustTextColor(QuizPlayerStateProvider provider, int optionPos, quizPos) {
    var answers = provider.quizItems[quizPos].answers;
    var options = provider.quizItems[quizPos].playerOptions;
    if (provider.quizItems[quizPos].finalResult != null) {
      return options[optionPos].isSelected || answers.asMap().containsValue(optionPos) ? Colors.white : Colors.black;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizPlayerStateProvider playerStateProvider = Provider.of<QuizPlayerStateProvider>(context, listen: false);
    List<QuizPlayerOption> _playerOptions = playerStateProvider.quizItems[pos].playerOptions;
    List<Padding> _options = _playerOptions
        .asMap()
        .entries
        .map<Padding>(
          (option) => Padding(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
            child: Selector<QuizPlayerStateProvider, List<bool>>(
              selector: (context, stateProvider) => [
                stateProvider.quizItems[pos].playerOptions[option.key].isSelected,
                stateProvider.quizItems[pos].finalResult,
              ],
              builder: (context, dependencies, _) => CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Container(
                  child: Text(
                    option.value.text,
                    style: TextStyle(
                      color: adjustTextColor(playerStateProvider, option.key, pos),
                    ),
                  ),
                  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                  decoration: BoxDecoration(
                      color: adjustOptionColor(
                        dependencies[1],
                        option.key,
                        playerStateProvider.quizItems[pos].answers,
                        playerStateProvider,
                      ),
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                ),
                value: dependencies[0],
                onChanged:
                    dependencies[1] != null ? null : (bool value) => playerStateProvider.updateSelectedOption(pos, option.key, value),
              ),
            ),
          ),
        )
        .toList();

    UserInfoStateProvider userInfoStateProvider = locator<UserInfoStateProvider>();


    final bool isMyQuiz = playerStateProvider.quizCollection.author.id == playerStateProvider.quizCollection.author.id;

    showQuizEditWidget() async {
      await Future.delayed(Duration(milliseconds: 240));
      userInfoStateProvider.setBottomNavBarVisibilityTo(false);
      showModalBottomSheet(
              context: context,
              builder: (_) => ChangeNotifierProvider<EditQuizItemStateProvider>(
                    create: (context) => EditQuizItemStateProvider(playerStateProvider.quizItems[pos]),
                    builder: (context, _) => EditQuizItemModalSheetWidget(),
                  ),
              isDismissible: false,
              isScrollControlled: true,
              backgroundColor: Colors.transparent)
          .whenComplete(() async {
        await Future.delayed(Duration(milliseconds: 200));
        userInfoStateProvider.setBottomNavBarVisibilityTo(true);
      });
    }

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(ScreenUtil().setSp(30))),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: ScreenUtil().setHeight(100),
            //color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(50),
                    ),
                    Text(
                      'question ${pos + 1}',
                      style: TextStyle(fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold),
                    ),
                    if (isMyQuiz)
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      ),
                    if (isMyQuiz)
                      GestureDetector(
                        child: Text(
                          'edit',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        onTap: () {
                          print('Editing a quiz item');
                          userInfoStateProvider.setBottomNavBarVisibilityTo(false);
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => EditOrDeleteOptionWidget(
                              onEditText: 'Edit this question',
                              onDeleteText: 'Delete this question',
                              onDelete: () => playerStateProvider.deleteQuizItemAt(context, pos),
                              onEdit: () {
                                Navigator.of(context).pop();
                                showQuizEditWidget();
                              },
                            ),
                          ).whenComplete(() async {
                            await Future.delayed(Duration(milliseconds: 200));
                            userInfoStateProvider.setBottomNavBarVisibilityTo(true);
                          });
                        },
                      ),
                  ],
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(50),
                ),
                Selector<QuizPlayerStateProvider, bool>(
                  selector: (context, stateProvder) => stateProvder.quizItems[pos].finalResult,
                  builder: (context, result, _) {
                    if (result == null) {
                      return MaterialButton(
                        elevation: 2.0,
                        color: Colors.green,
                        onPressed: () => playerStateProvider.checkAnswer(pos),
                        child: Text(
                          'Check Answer',
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
                      );
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          result ? Icons.check_circle_outline_outlined : Icons.cancel_outlined,
                          size: ScreenUtil().setSp(70),
                          color: result ? Colors.green : Colors.red,
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(100),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setSp(60)),
            child: Text(playerStateProvider.quizItems[pos].question),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(60),
          ),
          ..._options,
          SizedBox(
            height: ScreenUtil().setHeight(60),
          ),
          Selector<QuizPlayerStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.quizItems[pos].finalResult,
            builder: (context, result, _) => result == null || playerStateProvider.quizItems[pos].explain == null
                ? Container()
                : SizedBox(
                    width: ScreenUtil.screenWidth,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Text(
                          playerStateProvider.quizItems[pos].explain.toString(),
                        ),
                      ),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}

final String explain = 'this occurs because of the fact that goes like if you fuck me i will love you until i die';
