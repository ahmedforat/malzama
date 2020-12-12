import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/comments_and_replies/add_comment_widget/add_comment_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';
import 'load_more_comments_btn.dart';
import 'replies/reply_display_page.dart';
import 'single_comment_widget.dart';
import 'state_providers/add_comment_widget_state_provider.dart';
import 'state_providers/comment_state_provider.dart';

class CommentsPage<T extends MaterialStateRepository> extends StatelessWidget {
  final int materialPos;

  CommentsPage({
    @required int pos,
  }) : this.materialPos = pos;

  @override
  Widget build(BuildContext context) {
    CommentStateProvider<T> commentStateProvider = Provider.of<CommentStateProvider<T>>(context, listen: false);

    AddOrEditCommentWidgetStateProvider addOrEditStateProvider = Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      addOrEditStateProvider.setIsCommentUpdatingTo(false);
    });
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        if (addOrEditStateProvider.focusNode.hasFocus) {
          addOrEditStateProvider.focusNode.unfocus();
        }
      },
      child: Scaffold(
        key: commentStateProvider.commentsScaffoldKey,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: commentStateProvider.pageController,
          children: [
            Scaffold(
              bottomNavigationBar: BottomSheetWidget<T>(),
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
                          Selector<CommentStateProvider<T>, int>(
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
                      child: LoadMoreCommentsButton<T>(),
                    ),
                    Expanded(
                      child: Selector<CommentStateProvider<T>, List<dynamic>>(
                        selector: (context, stateProvider) => [
                          stateProvider.isFetching,
                          stateProvider.comments.length,
                        ],
                        builder: (context, data, _) => (data.first as bool)
                            ? Center(child: CircularProgressIndicator())
                            : (data.last as int) == 0
                                ? Container(
                                    child: Center(
                                      child: Text(
                                        'No Comments to Show',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    key: new PageStorageKey('comments'),
                                    physics: BouncingScrollPhysics(),
                                    itemCount: data.last,
                                    //separatorBuilder: (context, pos) => pos != dummyComments.length - 1 ? Divider() : Container(),
                                    itemBuilder: (context, pos) => CommentWidget<T>(
                                      commentPos: pos,
                                    ),
                                  ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ReplyDisplayPage<T>()
          ],
        ),
      ),
    );
  }
}
