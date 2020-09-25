import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/custom_selector.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/failed_to_load_materials_widget.dart';
import '../../../../single_page_display_widgets/college_material_holding_widget.dart';
import 'package:provider/provider.dart';

class DisplayHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var homeStateProvider = getHomePageStateProvider(listen: false, context: context);
    final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.5),
//      appBar: AppBar(
//        title: Text('Hello Home Page'),
//      ),
      body: CustomHomePageSelectorWidget<List<dynamic>>(
          isAcademic: HelperFucntions.isAcademic(accountType),
          selector: (context, stateProvider) => [stateProvider.isFetching, stateProvider.myPDFSCount],
          builder: (context, dependencies, __) {
            if (dependencies[0]) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (dependencies[1] == -1) {
              return FailedToLoadMaterialsWidget(isVideo: false);
            }

            if (dependencies[1] == 0) {
              return Container(
                child: Center(
                  child: Text('No PDF lectures to show'),
                ),
              );
            }
            return _buildLecturesList(context, homeStateProvider);
          }),
    );
  }
}

Widget _buildLecturesList(BuildContext context, state) => RefreshIndicator(
      onRefresh: () async {
        await state.fetchPDFs();
      },
      child: ListView.builder(
        itemCount: state.myPDFS.length,
        itemBuilder: (context, pos) => CollegeMaterialHoldingWidget(
          state: state,
          pos: pos,
          materialType: 'pdf',
        ),
      ),
    );
