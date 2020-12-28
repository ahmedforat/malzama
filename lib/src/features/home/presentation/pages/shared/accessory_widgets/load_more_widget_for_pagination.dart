import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import 'package:provider/provider.dart';

class LoadMoreWidget<T extends MaterialStateRepository> extends StatelessWidget {
  final VoidCallback onLoadMore;

  const LoadMoreWidget({@required this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Selector<T, List<bool>>(
      selector: (context, MaterialStateRepository stateProvider) => [
        stateProvider.isPaginating,
        stateProvider.endOfResults,
        stateProvider.isPagintaionFailed,
      ],
      builder: (context, paginationOptions, _) {
        if (paginationOptions.first) {
          return Container(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(50),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Loading ... '),
                  SizedBox(
                    width: ScreenUtil().setWidth(30),
                  ),
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: ScreenUtil().setWidth(50),

                    height: ScreenUtil().setWidth(50),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                ],
              ),
            ),
          );
        }
        if (paginationOptions[1]) {
          return Center(child: Text('End Of Results'));
        }
        final failureText = 'Failed to load more, try again';
        final successText = 'Tap to load more';
        return RaisedButton(
          onPressed: onLoadMore,
          child: Text(paginationOptions.last ? failureText : successText),
        );
      },
    );
  }
}

class LoadMoreWidgetForQuizes<T extends QuizStateRepository> extends StatelessWidget {
  final VoidCallback onLoadMore;

  const LoadMoreWidgetForQuizes({@required this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Selector<T, List<bool>>(
      selector: (context, QuizStateRepository stateProvider) => [
        stateProvider.isPaginating,
        stateProvider.endOfResults,
        stateProvider.isPaginationFailed,
      ],
      builder: (context, paginationOptions, _) {
        if (paginationOptions.first) {
          return Container(
            width: ScreenUtil().setWidth(50),
            height: ScreenUtil().setHeight(50),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Loading ... '),
                  SizedBox(
                    width: ScreenUtil().setWidth(30),
                  ),
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: ScreenUtil().setWidth(50),
                    height: ScreenUtil().setWidth(50),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                ],
              ),
            ),
          );
        }
        if (paginationOptions[1]) {
          return Text('End Of Results');
        }
        final failureText = 'Failed to load more, try again';
        final successText = 'Tap to load more';
        return RaisedButton(
          onPressed: onLoadMore,
          child: Text(
            paginationOptions.last ? failureText : successText,
          ),
        );
      },
    );
  }
}
