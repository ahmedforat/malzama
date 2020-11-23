import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/user_info_provider.dart';
import '../../lectures_pages/state/pdf_state_provider.dart';
import '../comments_and_replies/commentsPage.dart';
import '../comments_and_replies/state_providers/add_comment_widget_state_provider.dart';
import '../comments_and_replies/state_providers/comment_state_provider.dart';

class CollegePDFDetailsPage extends StatelessWidget {
  final int pos;


  const CollegePDFDetailsPage({
    @required this.pos,
    bool addComment,
  });

  @override
  Widget build(BuildContext context) {
    PDFStateProvider pdfStateProvider = Provider.of<PDFStateProvider>(context, listen: false);

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
                                pdfStateProvider.materials[pos].topic,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                'Author: ' +
                                    pdfStateProvider.materials[pos].author.firstName +
                                    ' ' +
                                    pdfStateProvider.materials[pos].author.lastName,
                                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                'Published in: ' + pdfStateProvider.materials[pos].postDate.substring(0, 10),
                                style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                pdfStateProvider.materials[pos].author.university + ' / ' + pdfStateProvider.materials[pos].author.college,
                                style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(5),
                              ),
                              Text(
                                'Stage ${pdfStateProvider.materials[pos].stage}',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(35),
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setSp(25),
                            right: ScreenUtil().setSp(45),
                          ),
                          child: Text(
                            pdfStateProvider.materials[pos].title,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setSp(25)),
                          child: Text(
                            pdfStateProvider.materials[pos].description,
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
                                          builder: (context, commentCount, _) => Text('$commentCount Comments'),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {

                                      //CommentStateProvider commentStateProvider = Provider.of<CommentStateProvider>(context,listen: false);
                                      UserInfoStateProvider userStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
                                      userStateProvider.bottomSheetController = Scaffold.of(context).showBottomSheet(
                                        (context) => ChangeNotifierProvider<AddOrEditCommentWidgetStateProvider>(
                                          create: (context) => AddOrEditCommentWidgetStateProvider(),
                                          builder: (context, _) => Builder(
                                            builder: (context) => CommentsPage(

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
