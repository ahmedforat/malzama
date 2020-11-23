import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/Navigator/routes_names.dart';
import '../../../../../../../../core/platform/local_database/access_objects/quiz_access_object.dart';
import 'quiz_displayer_single_widget.dart';
import 'quiz_displayer_state_provider.dart';

class QuizListDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizDisplayerStateProvider displayerStateProvider = Provider.of<QuizDisplayerStateProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{

           var dd = await QuizAccessObject().getUploadedMaterials(MyUploaded.QUIZES);
           print(dd?.length ?? 'not found');
        },
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Selector<QuizDisplayerStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.isFetching,
            builder: (context, isFetching, _) {
              if (isFetching) {
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
              return Selector<QuizDisplayerStateProvider, int>(
                selector: (context, stateProvider) => stateProvider.quizCollections.length,
                builder: (context, count, _) {
                  if (count == 0) {
                    return Container(
                      child: Center(
                        child: Text('No Quizes'),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: displayerStateProvider.quizCollections.length,
                    itemBuilder: (context, pos) => pos == displayerStateProvider.quizCollections.length - 1 && pos > 7
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () => Navigator.pushNamed(
                                        context,
                                        RouteNames.TAKE_QUIZ_EXAM,
                                        arguments: {
                                          'data': displayerStateProvider.quizCollections[pos],
                                          'fromLocal': false,
                                        },
                                      ),
                                  child: QuizDisplayerSingleWidget(pos: pos)),
                              SizedBox(
                                height: ScreenUtil().setHeight(30),
                              ),
                              LoadMoreWidget(),
                            ],
                          )
                        : InkWell(
                            onTap: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.TAKE_QUIZ_EXAM,
                                  arguments: {
                                    'data': displayerStateProvider.quizCollections[pos],
                                    'fromLocal': false,
                                  },
                                ),
                            child: QuizDisplayerSingleWidget(pos: pos)),
                  );
                },
              );
            }),
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

class LoadMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizDisplayerStateProvider displayerStateProvider = Provider.of<QuizDisplayerStateProvider>(context, listen: false);
    return Selector<QuizDisplayerStateProvider, List<bool>>(
      selector: (context, stateProvider) => [stateProvider.isPaginating, stateProvider.endOfResult, stateProvider.failedToPaginateQuizes],
      builder: (context, paginationOptions, _) {
        if (paginationOptions[0]) {
          return Container(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(50),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (paginationOptions[1]) {
          return Text('End Of Results');
        }
        final failureText = 'Failed to load more, try again';
        final successText = 'Tap to load more';
        return RaisedButton(
          onPressed: () {
            displayerStateProvider.startPaginationFetching();
          },
          child: Text(paginationOptions[2] ? failureText : successText),
        );
      },
    );
  }
}
