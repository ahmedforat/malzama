import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_list_displayer/quiz_displayer_single_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_list_displayer/quiz_displayer_state_provider.dart';
import 'package:provider/provider.dart';

class QuizListDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizDisplayerStateProvider displayerStateProvider = Provider.of<QuizDisplayerStateProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print(displayerStateProvider.quizCollections.first.quizItems.first.toJSON());
        },
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Selector<QuizDisplayerStateProvider, bool>(
          selector: (context, stateProvider) => stateProvider.isFetching,
          builder: (context, isFetching, _) => isFetching
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Selector<QuizDisplayerStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.quizCollections.length,
                  builder: (context, count, _) {
                    if (displayerStateProvider.isFetching) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (displayerStateProvider.failedToFetchQuizes) {
                      return FailedToLoadWidget(
                        message: 'Failed To Load Quizes',
                        onReload: () => displayerStateProvider.startInitializeFetching(),
                      );
                    }
                    if (count == 0) {
                      return Container(
                        child: Center(
                          child: Text('No Quizes'),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: displayerStateProvider.quizCollections.length,
                      itemBuilder: (context, pos) => pos == displayerStateProvider.quizCollections.length && pos > 7
                          ? RaisedButton(
                              onPressed: () {},
                              child: Text('Tap to load more'),
                            )
                          : InkWell(
                              onTap: () => Navigator.pushNamed(context, RouteNames.TAKE_QUIZ_EXAM,
                                  arguments: displayerStateProvider.quizCollections[pos]),
                              child: QuizDisplayerSingleWidget(pos: pos)),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class FailedToLoadWidget extends StatelessWidget {
  final String message;
  final VoidCallback onReload;
  final String buttonText;

  FailedToLoadWidget({@required this.message, @required this.onReload, String text}) : buttonText = text ?? 'Reload';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizDisplayerStateProvider displayerStateProvider = Provider.of<QuizDisplayerStateProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            RaisedButton(
              child: Text(
                buttonText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: onReload,
            ),
          ],
        ),
      ),
    );
  }
}
