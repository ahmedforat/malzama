import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_quizes_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/load_more_widget_for_pagination.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/no_materials_yet_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/material_holding_widgets/college/college_quiz_holding_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/material_holding_widgets/school/school_quiz_holding_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import 'package:provider/provider.dart';

class SavedQuizesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MySavedQuizStateProvider savedQuizesStateProvider = Provider.of<MySavedQuizStateProvider>(context, listen: false);
    return Scaffold(
      key: savedQuizesStateProvider.scaffoldKey,
      body: Selector<MySavedQuizStateProvider, List<bool>>(
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
            return FailedToLoadMaterialsWidget(
              onReload: savedQuizesStateProvider.fetchInitialData,
              message: 'Failed to load saved quizes',
              onReloadOnly: true,
            );
          }

          return Selector<MySavedQuizStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.materials.length,
            builder: (context, count, _) {
              if (savedQuizesStateProvider.materials.isEmpty) {
                return NoMaterialYetWidget(
                  onReload: savedQuizesStateProvider.fetchInitialData,
                  materialName: 'saved quizes',
                );
              }

              return ListView.builder(
                itemCount: count,
                itemBuilder: (context, pos) {
                  if (pos == count - 1 && count >= 7) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        savedQuizesStateProvider.isAcademic
                            ? CollegeQuizHoldingWidget<MySavedQuizStateProvider>(pos: pos)
                            : SchoolQuizHoldingWidget<MySavedQuizStateProvider>(pos: pos),
                        SizedBox(
                          height: ScreenUtil().setHeight(30),
                        ),
                        LoadMoreWidgetForQuizes<MySavedQuizStateProvider>(
                          onLoadMore: savedQuizesStateProvider.fetchForPagination,
                        ),
                      ],
                    );
                  }

                  return savedQuizesStateProvider.isAcademic
                      ? CollegeQuizHoldingWidget<MySavedQuizStateProvider>(
                          pos: pos,
                        )
                      : SchoolQuizHoldingWidget<MySavedQuizStateProvider>(pos: pos);
                },
              );
            },
          );
        },
      ),
    );
  }
}
