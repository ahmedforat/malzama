import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/videos_page_custom_selector.dart';
import 'package:provider/provider.dart';

import './comments_and_replies/commentsPage.dart';
import '../../state_provider/user_info_provider.dart';
import '../pages_navigators/home_page_navigator/home_page_navigator/state/state_getter.dart';
import '../pages_navigators/videos_navigator/state/state_getter.dart';
import 'college_material_holding_widget.dart';
import 'comments_and_replies/state_providers/add_comment_widget_state_provider.dart';
import 'comments_and_replies/state_providers/comment_state_provider.dart';

class CollegeMaterialViewPage extends StatelessWidget {
  final int pos;
  final bool isVideo;
  final bool addComment;

  CollegeMaterialViewPage({
    @required this.isVideo,
    @required this.pos,
    bool addComment,
  }) : this.addComment = addComment ?? false;

  var state;

  @override
  Widget build(BuildContext context) {
    state = isVideo
        ? getVideosPageStateProvider(
            context: context,
            listen: false,
          )
        : getHomePageStateProvider(
            context: context,
            listen: false,
          );

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(500),
                          child: Placeholder(),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(25)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                isVideo ? state.videos[pos].topic.toString() : state.myPDFS[pos].topic.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                isVideo
                                    ? 'Author: ' + state.videos[pos].author['firstName'] + ' ' + state.videos[pos].author['lastName']
                                    : 'Author: ' + state.myPDFS[pos].author['firstName'] + ' ' + state.myPDFS[pos].author['lastName'],
                                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                isVideo
                                    ? 'Published in: ' + state.videos[pos].post_date.toString().substring(0, 10)
                                    : 'Published in: ' + state.myPDFS[pos].post_date.toString().substring(0, 10),
                                style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                isVideo
                                    ? state.videos[pos].university + ' / ' + state.videos[pos].college
                                    : state.myPDFS[pos].university + ' / ' + state.myPDFS[pos].college,
                                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                'Stage ${isVideo ? state.videos[pos].stage : state.myPDFS[pos].stage}',
                                style: TextStyle(fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().setSp(25), right: ScreenUtil().setSp(45)),
                          child: Text(
                            isVideo ? state.videos[pos].title.toString() : state.myPDFS[pos].title.toString() + "tem of the human",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(25)),
                          child: Text(
                            isVideo ? state.videos[pos].description ?? '' : state.myPDFS[pos].description ?? '',
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(80),
                        ),
                        Builder(
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(25)),
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                    right: ScreenUtil().setSp(25),
                                  ),
                                  child: RaisedButton(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Tab to view Comments'),
                                        Selector<CommentStateProvider, int>(
                                          selector: (context, stateProvider) => stateProvider.state.comments.length,
                                          builder: (context, commentCount, _) => Text('$commentCount Comments'
//                                isVideo
//                                    ? state.videos[pos].comments.length.toString() + ' Comments'
//                                    : state.myPDFS[pos].comments.length.toString() + ' Comments',
                                              ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      final args = {'pos': pos, 'isVideo': isVideo};
                                      //CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context,listen: false);
                                      UserInfoStateProvider userStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
                                      userStateProvider.bottomSheetController = Scaffold.of(context).showBottomSheet(
                                        (context) => ChangeNotifierProvider<AddOrEditCommentWidgetStateProvider>(
                                          create: (context) => AddOrEditCommentWidgetStateProvider(),
                                          builder: (context, _) => Builder(
                                            builder: (context) => CommentsPage(
                                              isVideo: isVideo,
                                              pos: pos,
                                            ),
                                          ),
                                        ),
                                      );

                                      //navBarController.setBottomNavBarVisibilityTo(false);
//                                    navBarController.bottomSheetController.closed.then((_) => navBarController.setBottomNavBarVisibilityTo(true));
                                    },
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
