import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/quiz_player_state_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizPlayerStateProvider playerStateProvider = Provider.of<QuizPlayerStateProvider>(context, listen: false);
    List<QuizPlayerOption> _playerOptions = playerStateProvider.quizItems[pos].playerOptions;
    final bool hasExplanation = playerStateProvider.quizItems[pos].explain.toString() != 'null';
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
                  child: Text(option.value.text),
                  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                  color: adjustOptionColor(
                    dependencies[1],
                    option.key,
                    playerStateProvider.quizItems[pos].answers,
                    playerStateProvider,
                  ),
                ),
                value: dependencies[0],
                onChanged:
                    dependencies[1] != null ? null : (bool value) => playerStateProvider.updateSelectedOption(pos, option.key, value),
              ),
            ),
          ),
        )
        .toList();
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('question ${pos + 1}'),
              SizedBox(
                width: ScreenUtil().setWidth(50),
              ),
              Selector<QuizPlayerStateProvider,bool>(
                selector: (context,stateProvder) => stateProvder.quizItems[pos].finalResult,
                builder:(context,isChecked,_) => MaterialButton(
                  elevation: 2.0,
                  color: Colors.green,
                  onPressed: isChecked != null ? null : () => playerStateProvider.checkAnswer(pos),
                  child: Text('Check Your Answer(s)'),
                ),
              )
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Text(playerStateProvider.quizItems[pos].question),
          SizedBox(
            height: ScreenUtil().setHeight(60),
          ),
          ..._options,
          SizedBox(
            height: ScreenUtil().setHeight(60),
          ),
          Selector<QuizPlayerStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.quizItems[pos].finalResult,
            builder: (context, result, _) => result == null
                ? Container()
                : Text(
                    explain + explain + explain + explain ?? playerStateProvider.quizItems[pos].explain.toString(),
                  ),
          )
        ]),
      ),
    );
  }
}

final String explain = 'this occurs because of the fact that goes like if you fuck me i will love you until i die';
