import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/my_saved_common_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_quizes_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/saved_pdf_list.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/saved_quizes_list.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/widgets/saved_videos_list.dart';
import 'package:provider/provider.dart';

class MySavedMaterialPage extends StatefulWidget {
  @override
  _MySavedMaterialPageState createState() => _MySavedMaterialPageState();
}

class _MySavedMaterialPageState extends State<MySavedMaterialPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    SavedCommonState mySavedStateProvider = Provider.of<SavedCommonState>(context, listen: false);

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
                          Text('My Saved ', style: TextStyle(fontSize: ScreenUtil().setSp(50))),
                          Icon(
                            Icons.bookmark,
                            size: ScreenUtil().setSp(60),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Selector<MySavedPDFStateProvider, int>(
                          selector: (context, statProvider) => statProvider.savedLectures.length,
                          builder: (context, lecturesCount, _) => CountIndicatorWidget(
                            text: 'lectures',
                            count: lecturesCount,
                            tabIndex: 0,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Selector<MySavedVideosStateProvider, int>(
                          selector: (context, statProvider) => statProvider.savedVideos.length,
                          builder: (context, videosCount, _) => CountIndicatorWidget(
                            text: 'videos',
                            count: videosCount,
                            tabIndex: 1,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Selector<MySavedQuizesStateProvider, int>(
                          selector: (context, statProvider) => statProvider.savedQuizes.length,
                          builder: (context, quizesCount, _) => CountIndicatorWidget(
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
                  controller: mySavedStateProvider.pageController,
                  onPageChanged: mySavedStateProvider.onPageChange,
                  children: [
                    SavedPDFList(),
                    SavedVideosList(),
                    SavedQuizesList(),
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

class CountIndicatorWidget extends StatelessWidget {
  final String text;
  final int count;
  final int tabIndex;

  const CountIndicatorWidget({
    @required this.text,
    @required this.count,
    @required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    SavedCommonState mySavedStateProvider = Provider.of<SavedCommonState>(context, listen: false);
    return Selector<SavedCommonState, int>(
      selector: (context, stateProvider) => stateProvider.currentTabIndex,
      builder: (context, index, _) => GestureDetector(
        onTap: () async {
          if (mySavedStateProvider.currentTabIndex != tabIndex) {
            await mySavedStateProvider.animateToPage(tabIndex);


          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.linearToEaseOut,
          padding: EdgeInsets.all(ScreenUtil().setSp(tabIndex == index ? 20 : 15)),
          decoration: BoxDecoration(
            color: tabIndex == index ? Colors.redAccent : Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
            border: Border.all(color: Colors.transparent),
          ),
          child: Text(
            '$text: $count ',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              color: tabIndex == index ? Colors.white : Colors.black,
              fontWeight: tabIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
