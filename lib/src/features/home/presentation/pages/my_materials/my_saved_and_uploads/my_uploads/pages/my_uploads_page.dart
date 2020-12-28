import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/widgets/uploaded_lectures_list.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/widgets/uploaded_quizes_list.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/widgets/uploaded_videos_list.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/sub_widgets/count_indicator_widget.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class MyUploadsPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MyUploadsStateProvider myUploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().setSp(10),
                        left: ScreenUtil().setSp(30),
                        bottom: ScreenUtil().setSp(30),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Uploads ', style: TextStyle(fontSize: ScreenUtil().setSp(50))),
                          Icon(
                            Icons.bookmark,
                            size: ScreenUtil().setSp(60),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Selector<MyUploadsStateProvider, int>(
                          selector: (context, statProvider) => statProvider.uploadedLectures.length,
                          builder: (context, lecturesCount, _) => CountIndicatorWidget<MyUploadsStateProvider>(
                            text: 'lectures',
                            count: lecturesCount,
                            tabIndex: 0,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Selector<MyUploadsStateProvider, int>(
                          selector: (context, statProvider) => statProvider.uploadedVideos.length,
                          builder: (context, videosCount, _) => CountIndicatorWidget<MyUploadsStateProvider>(
                            text: 'videos',
                            count: videosCount,
                            tabIndex: 1,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Selector<MyUploadsStateProvider, int>(
                          selector: (context, statProvider) => statProvider.uploadedQuizes.length,
                          builder: (context, quizesCount, _) => CountIndicatorWidget<MyUploadsStateProvider>(
                            text: 'quizes',
                            count: quizesCount,
                            tabIndex: 2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: myUploadsStateProvider.pageController,
                  onPageChanged: myUploadsStateProvider.onPageChange,
                  children: [
                    RefreshIndicator(
                      child: UploadedLecturesList(),
                      onRefresh: () async {
                        print('from page view lectuers');
                        Provider.of<MyUploadsStateProvider>(context, listen: false).fetchLectures();
                        locator<UserInfoStateProvider>().fetchUploadedMaterialsCount();
                      },
                    ),
                    RefreshIndicator(
                      child: UploadedVideosList(),
                      onRefresh: () async {
                        print('from page view videos');
                        Provider.of<MyUploadsStateProvider>(context, listen: false).fetchVideos();
                        locator<UserInfoStateProvider>().fetchUploadedMaterialsCount();
                      },
                    ),
                    RefreshIndicator(
                      child: UploadedQuizesList(),
                      onRefresh: () async {
                        print('from page view quizes');
                        Provider.of<MyUploadsStateProvider>(context, listen: false).fetchQuizes();
                        locator<UserInfoStateProvider>().fetchUploadedMaterialsCount();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
