import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/load_more_widget_for_pagination.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/no_materials_yet_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import 'package:provider/provider.dart';

import '../../../../shared/material_holding_widgets/college/college_video_holding_widget.dart';
import '../../../../shared/material_holding_widgets/school/school_video_holding_widget.dart';
import '../state_provider/saved_videos_state_provider.dart';

class SavedVideosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MySavedVideoStateProvider savedVideoStateProvider = Provider.of<MySavedVideoStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return Scaffold(
      key: savedVideoStateProvider.scaffoldKey,
      body: Selector<MySavedVideoStateProvider, List<bool>>(
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
              onReload: savedVideoStateProvider.fetchInitialData,
              message: 'Failed to load saved videos',
              onReloadOnly: true,
            );
          }

          if (savedVideoStateProvider.materials.isEmpty) {
            return NoMaterialYetWidget(
              onReload: savedVideoStateProvider.fetchInitialData,
              materialName: 'saved videos',
            );
          }

          return Selector<MySavedVideoStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.materials.length,
            builder: (context, count, _) => ListView.builder(
              itemCount: count,
              itemBuilder: (context, pos) {
                if (pos == count - 1 && count >= 7) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      savedVideoStateProvider.isAcademic
                          ? CollegeVideoHoldingWidget<MySavedVideoStateProvider>(pos: pos)
                          : SchoolVideoHoldingWidget<MySavedVideoStateProvider>(pos: pos),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      LoadMoreWidget<MySavedVideoStateProvider>(
                        onLoadMore: savedVideoStateProvider.fetchForPagination,
                      ),
                    ],
                  );
                }

                return savedVideoStateProvider.isAcademic
                    ? CollegeVideoHoldingWidget<MySavedVideoStateProvider>(
                        pos: pos,
                      )
                    : SchoolVideoHoldingWidget<MySavedVideoStateProvider>(pos: pos);
              },
            ),
          );
        },
      ),
    );
  }
}
