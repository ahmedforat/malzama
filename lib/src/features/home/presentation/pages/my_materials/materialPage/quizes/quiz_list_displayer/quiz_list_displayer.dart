import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/quizes/quiz_list_displayer/quiz_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/load_more_widget_for_pagination.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/no_materials_yet_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/material_holding_widgets/school/school_quiz_holding_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import 'package:provider/provider.dart';

import '../../../../shared/material_holding_widgets/college/college_quiz_holding_widget.dart';

class QuizListDisplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizStateProvider quizStateProvider = Provider.of<QuizStateProvider>(context, listen: false);
    return Scaffold(
      key: quizStateProvider.scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //var dd = await QuizAccessObject().getUploadedMaterials(MyUploaded.QUIZES);
          // var dd = await QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES);
          var dd = quizStateProvider.materials.length;
          //dd.first.remove('questions');
          // Map<String, dynamic> d = {...dd.first};
          // d.remove('questions');
          print(dd);
          //  print('deleted');
        },
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Selector<QuizStateProvider, List<bool>>(
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
                message: 'Failed To Load Quizes',
                onReload: quizStateProvider.fetchInitialData,
              );
            }
            return Selector<QuizStateProvider, bool>(
              selector: (context, stateProvider) => stateProvider.hasQuizes,
              builder: (context, hasQuizes, _) {
                if (!hasQuizes) {
                  return NoMaterialYetWidget(
                    materialName: 'Quizes',
                    onReload: quizStateProvider.fetchInitialData,
                  );
                }
                return Selector<QuizStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.materials.length,
                  builder: (context, count, _) => ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, pos) => pos == count - 1 && count >= 10
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              quizStateProvider.isAcademic
                                  ? CollegeQuizHoldingWidget<QuizStateProvider>(pos: pos)
                                  : SchoolQuizHoldingWidget<QuizStateProvider>(pos: pos),
                              SizedBox(
                                height: ScreenUtil().setHeight(30),
                              ),
                              LoadMoreWidgetForQuizes<QuizStateProvider>(
                                onLoadMore: quizStateProvider.fetchForPagination,
                              ),
                            ],
                          )
                        : quizStateProvider.isAcademic
                            ? CollegeQuizHoldingWidget<QuizStateProvider>(pos: pos)
                            : SchoolQuizHoldingWidget<QuizStateProvider>(pos: pos),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
