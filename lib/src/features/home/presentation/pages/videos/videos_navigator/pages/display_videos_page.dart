import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../state_provider/user_info_provider.dart';
import '../../../shared/single_page_display_widgets/failed_to_load_materials_widget.dart';
import '../../widgets/college_video_holding_widget.dart';
import '../../widgets/school_video_holding_widget.dart';
import '../state/video_state_provider.dart';

class DisplayVideosPage extends StatefulWidget {
  @override
  _DisplayVideosPageState createState() => _DisplayVideosPageState();
}

class _DisplayVideosPageState extends State<DisplayVideosPage> {
  @override
  Widget build(BuildContext context) {
    final String accountType = Provider
        .of<UserInfoStateProvider>(context, listen: false)
        .userData.accountType;
    final bool isAcademic = HelperFucntions.isAcademic(accountType);
    return Selector<VideoStateProvider, List<dynamic>>(
        selector: (context, stateProvider) =>
        [
          stateProvider.isFetching,
          stateProvider.materials.length,
          stateProvider.failureOfInitialFetch,
        ],
        builder: (context, data, child) {
          if (data[0]) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (data[2]) {
            return FailedToLoadMaterialsWidget(isVideo: true);
          }

          if (data[1] == 0) {
            return Container(
              child: Center(
                child: Text('No Videos To Show!!'),
              ),
            );
          }
          return materials();
        });
  }



}


class materials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoStateProvider videoStateProvider = Provider.of<VideoStateProvider>(context, listen: false);
    UserInfoStateProvider userInfo = Provider.of<UserInfoStateProvider>(context, listen: false);
    bool isAcademic = HelperFucntions.isAcademic(userInfo.userData.accountType);

    return RefreshIndicator(
      onRefresh: () async {
        await videoStateProvider.onRefresh();
        return;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(20)),
          color: Colors.grey.withOpacity(0.3),
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: videoStateProvider.materials.length,
            itemBuilder: (context, pos) =>
            isAcademic ? CollegeVideoHoldingWidget(
              pos: pos,
            ) : SchoolVideoHoldingWidget(pos: pos),
          ),
        ),
      ),
    );
  }
}

