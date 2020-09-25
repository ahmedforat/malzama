import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/general_widgets/videos_page_custom_selector.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/videos_navigator/state/state_getter.dart';
import '../../../single_page_display_widgets/college_material_holding_widget.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/failed_to_load_materials_widget.dart';
import 'package:provider/provider.dart';

class DisplayVideosPage extends StatefulWidget {
  @override
  _DisplayVideosPageState createState() => _DisplayVideosPageState();
}

class _DisplayVideosPageState extends State<DisplayVideosPage> {
  @override
  Widget build(BuildContext context) {
    var videosStateProvider = getVideosPageStateProvider(context: context, listen: false);
    final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    final bool isAcademic = HelperFucntions.isAcademic(accountType);
    return DisplayVideosCustomSelector<List<dynamic>>(
        isAcademic: isAcademic,
        selector: (context, stateProvider) => [stateProvider.isFetching, stateProvider.videosCount],
        builder: (context, dependencies, child) {
          if (dependencies[0]) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (dependencies[1] == -1) {
            return FailedToLoadMaterialsWidget(isVideo: true);
          }

          if (dependencies[1] == 0) {
            return Container(
              child: Center(
                child: Text('No Videos To Show!!'),
              ),
            );
          }
          return _buildVideosList(context, videosStateProvider);
        });
  }

  Widget _buildVideosList(BuildContext context, state) {
    return RefreshIndicator(
      onRefresh: () async {
        await state.fetchVideos();
        return;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(20)),
          color: Colors.grey.withOpacity(0.3),
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: state.videos.length,
            itemBuilder: (context, pos) => CollegeMaterialHoldingWidget(
              pos: pos,
              state: state,
              materialType: 'video',
            ),
          ),
        ),
      ),
    );
  }
}
