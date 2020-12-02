import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_quizes_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/college_holding_widgets/saved_college_pdf_holding_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/school_holding_widgets/saved_school_pdf_holding_widget.dart';
import 'package:provider/provider.dart';

class SavedQuizesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MySavedQuizesStateProvider savedQuizesStateProvider = Provider.of<MySavedQuizesStateProvider>(context, listen: false);
    return Selector<MySavedQuizesStateProvider, List<bool>>(
      selector: (context, stateProvider) => [
        stateProvider.isFetchingSavedQuizes,
        stateProvider.noData,
        stateProvider.failedInitialFetch,
      ],
      builder: (context, data, _) {
        if (data.first) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (data[1]) {
          return Container(
            child: Center(
              child: Text(savedQuizesStateProvider.failureMessage),
            ),
          );
        }

        if (data.last) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(savedQuizesStateProvider.failureMessage),
                  RaisedButton(
                    child: Text('Reload'),
                    onPressed: savedQuizesStateProvider.fetchInitialSavedQuizes,
                  )
                ],
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: Selector<MySavedQuizesStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.savedQuizes.length,
            builder: (context, count, _) => ListView.builder(
              itemCount: count,
              itemBuilder: (context, pos) => savedQuizesStateProvider.userData.isAcademic
                  ? Container(
                      child: Center(
                        child: Text('No implemented Yet'),
                      ),
                    )
                  : Container(
                      child: Text('NotImplemented yet'),
                    ),
            ),
          ),
        );
      },
    );
  }
}
