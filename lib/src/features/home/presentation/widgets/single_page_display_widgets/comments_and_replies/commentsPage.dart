import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/navigation_service.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/replies/reply_display_page.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';
import 'add_comment_widget/add_comment_bottom_sheet_widget.dart';
import 'load_more_comments_btn.dart';
import 'single_comment_widget.dart';
import 'state_providers/add_comment_widget_state_provider.dart';
import 'state_providers/comment_state_provider.dart';

PersistentBottomSheetController _bottomSheetController;

class CommentsPage extends StatelessWidget {
  final int materialPos;
  final bool isVideo;

  CommentsPage({
    @required this.isVideo,
    @required int pos,
  }) : this.materialPos = pos;

  @override
  Widget build(BuildContext context) {
    CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context, listen: false);
    AddOrEditCommentWidgetStateProvider addOrEditStateProvider = Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addOrEditStateProvider.setIsCommentUpdatingTo(false);
    });
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {},
      child: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: commentStateProvider.pageController,
        children: [
          Scaffold(
            bottomNavigationBar: BottomSheetWidget(),
            body: Container(
              decoration: BoxDecoration(
                //color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(ScreenUtil().setSp(30)),
                  topLeft: Radius.circular(ScreenUtil().setSp(70)),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              height: ScreenUtil().setHeight(1740),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(300)),
                      child: Container(
                        //width: ScreenUtil().setWidth(50) ,
                        height: ScreenUtil().setHeight(20),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setSp(70),
                          ),
                        ),
                      ),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Selector<CommentStateProvider, int>(
                          selector: (context, stateProvider) => stateProvider.state.comments.length,
                          builder: (context, count, _) => Text('$count comments'),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            print('closing the bottom sheet');
                            Provider.of<UserInfoStateProvider>(context, listen: false).bottomSheetController.close();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
                    child: LoadMoreCommentsButton(),
                  ),
                  Expanded(
                    child: Selector<CommentStateProvider, int>(
                      selector: (context, stateProvider) => stateProvider.comments.length,
                      builder: (context, commentsCount, _) => commentsCount == 0
                          ? Container(
                              child: Center(
                                child: Text(
                                  'No Comments to Show',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : commentStateProvider.isFetching
                              ? CircularProgressIndicator()
                              : ListView.builder(
                                  key: new PageStorageKey('comments'),
                                  physics: BouncingScrollPhysics(),
                                  itemCount: commentsCount,
                                  //separatorBuilder: (context, pos) => pos != dummyComments.length - 1 ? Divider() : Container(),
                                  itemBuilder: (context, pos) => GestureDetector(
                                    onTap: () {
//                                    _pageController.animateToPage(
//                                      1,
//                                      duration: Duration(milliseconds: 400),
//                                      curve: Curves.easeInOut,
//                                    );
                                    },
                                    child: CommentWidget(
                                      commentPos: pos,
                                    ),
                                  ),
                                ),
                    ),
                  )
                ],
              ),
            ),
          ),
          ReplyDisplayPage()
        ],
      ),
    );
  }
}
