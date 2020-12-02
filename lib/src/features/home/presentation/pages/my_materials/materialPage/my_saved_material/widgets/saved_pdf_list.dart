import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/college_holding_widgets/saved_college_pdf_holding_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/school_holding_widgets/saved_school_pdf_holding_widget.dart';
import 'package:provider/provider.dart';

class SavedPDFList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MySavedPDFStateProvider savedPDFStateProvider = Provider.of<MySavedPDFStateProvider>(context, listen: false);
    return Selector<MySavedPDFStateProvider, List<bool>>(
      selector: (context, stateProvider) => [
        stateProvider.isFetching,
        stateProvider.failureOfInitialFetch,
      ],
      builder: (context, data, _) {
        if (data.first) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (data.last) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    savedPDFStateProvider.failureMessage,
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    child: Text('Reload'),
                    onPressed: savedPDFStateProvider.fetchInitialData,
                  )
                ],
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: Selector<MySavedPDFStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.savedLectures.length,
            builder: (context, count, _) => ListView.builder(
                itemCount: count,
                itemBuilder: (context, pos) {
                  if (count == 0) {
                    return Container(
                      child: Center(
                        child: Text('No saved lectures available'),
                      ),
                    );
                  }

                  if (savedPDFStateProvider.userData.isAcademic) {
                    return SavedCollegePDFHoldingWidget(pos: pos);
                  }
                  return SavedSchoolPDFHoldingWidget(pos: pos);
                }),
          ),
        );
      },
    );
  }
}
