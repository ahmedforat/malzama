import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'package:provider/provider.dart';

import '../state_provider/my_saved_common_state_provider.dart';
import '../state_provider/saved_pdf_state_provider.dart';
import '../state_provider/saved_quizes_state_provider.dart';
import '../widgets/saved_pdf_list.dart';
import '../widgets/saved_quizes_list.dart';
import '../widgets/saved_videos_list.dart';

class MySavedMaterialPage extends StatefulWidget {
  @override
  _MySavedMaterialPageState createState() => _MySavedMaterialPageState();
}

class _MySavedMaterialPageState extends State<MySavedMaterialPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
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
                          selector: (context, statProvider) => statProvider.savedLectuersIds.length,
                          builder: (context, lecturesCount, _) => CountIndicatorWidget(
                            text: 'lectures',
                            count: lecturesCount,
                            tabIndex: 0,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Selector<MySavedVideoStateProvider, int>(
                          selector: (context, statProvider) => statProvider.savedVideosIds.length,
                          builder: (context, videosCount, _) => CountIndicatorWidget(
                            text: 'videos',
                            count: videosCount,
                            tabIndex: 1,
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Selector<MySavedQuizStateProvider, int>(
                          selector: (context, statProvider) => statProvider.savedQuizesIds.length,
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
                    RefreshIndicator(
                      child: SavedPDFList(),
                      onRefresh: ()async{
                        print('from single');
                        await Provider.of<MySavedPDFStateProvider>(context, listen: false).onRefresh();
                      },
                    ),
                    RefreshIndicator(
                      child: SavedVideosList(),
                      onRefresh: ()async{
                        print('from single list');
                        Provider.of<MySavedVideoStateProvider>(context, listen: false).onRefresh();
                      },
                    ),
                    RefreshIndicator(
                      child: SavedQuizesList(),
                      onRefresh: Provider.of<MySavedQuizStateProvider>(context, listen: false).onRefresh,
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
