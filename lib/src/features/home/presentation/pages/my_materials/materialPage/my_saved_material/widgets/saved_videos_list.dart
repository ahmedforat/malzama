import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/school_holding_widgets/saved_school_video_holding_widget.dart';
import 'package:provider/provider.dart';

import 'college_holding_widgets/saved_college_video_holding_widget.dart';

class SavedVideosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MySavedVideosStateProvider savedVideosStateProvider = Provider.of<MySavedVideosStateProvider>(context, listen: false);
    return Selector<MySavedVideosStateProvider, List<bool>>(
      selector: (context, stateProvider) => [
        stateProvider.isFetchingSavedVideos,
        stateProvider.noData,
        stateProvider.failedInitialFetch
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
              child: Text(savedVideosStateProvider.failureMessage),
            ),
          );
        }

        if (data.last) {
          return Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(savedVideosStateProvider.failureMessage),
                  RaisedButton(
                    child: Text('Reload'),
                    onPressed: savedVideosStateProvider.fetchInitialSavedVideos,
                  )
                ],
              ),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: Selector<MySavedVideosStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.savedVideos.length,
            builder: (context, count, _) => ListView.builder(
              itemCount: count,
              itemBuilder: (context, pos) => savedVideosStateProvider.userData.isAcademic
                  ? SavedCollegeVideoHoldingWidget(
                      pos: pos,
                    )
                  : SavedSchoolVideoHoldingWidget(
                      pos: pos,
                    ),
            ),
          ),
        );
      },
    );
  }
}
