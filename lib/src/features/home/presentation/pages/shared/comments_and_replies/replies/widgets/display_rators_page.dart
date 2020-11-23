import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../state_provider/user_info_provider.dart';
import '../../comment_related_models/comment_rating_model.dart';

class DisplayRatorsPage extends StatefulWidget {
  final List<CommentRating> ratingsList;

  DisplayRatorsPage({@required this.ratingsList});

  @override
  _DisplayRatorsPageState createState() => _DisplayRatorsPageState();
}

class _DisplayRatorsPageState extends State<DisplayRatorsPage> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int helpfulRatings;
  int disHelpfulRatings;
  int total;
  TextStyle _textStyle;

  // GlobalKey totalKey;
  //
  // GlobalKey helpfulKey;
  // GlobalKey disHelpfulKey;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
    helpfulRatings = widget.ratingsList.where((element) => element.ratingType).length;
    disHelpfulRatings = widget.ratingsList.where((element) => !element.ratingType).length;
    total = widget.ratingsList.length;
    _textStyle = new TextStyle(color: Colors.black);
    // totalKey =  new GlobalKey() ;
    // helpfulKey =  new GlobalKey();
    // disHelpfulKey =  new GlobalKey();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
    print(widget.ratingsList[0].author.profilePictureRef);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(ScreenUtil().setSp(50)),
          topLeft: Radius.circular(ScreenUtil().setSp(50)),
        ),
      ),
      height: ScreenUtil().setHeight(1500),
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Column(
        children: [
          Padding(
            child: Container(
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(30)),
              ),
            ),
            padding: EdgeInsets.only(
                left: ScreenUtil().setSp(350), right: ScreenUtil().setSp(350), top: ScreenUtil().setSp(10), bottom: ScreenUtil().setSp(50)),
          ),
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setSp(500)),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Text(
                    'Total',
                    style: _textStyle,
                  ),
                  child: Text(
                    '$total',
                    style: _textStyle,
                  ),
                ),
                Tab(
                  child: Text(
                    '$helpfulRatings',
                    style: _textStyle,
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.thumbsUp,
                    color: Colors.blueAccent,
                  ),
                ),
                Tab(
                  child: Text(
                    '$disHelpfulRatings',
                    style: _textStyle,
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.thumbsDown,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ListBuilder(
                  ratingType: '',
                  ratingsList: widget.ratingsList,
                ),
                _ListBuilder(
                  ratingType: 'Helpful',
                  ratingsList: widget.ratingsList.where((element) => element.ratingType).toList(),
                ),
                _ListBuilder(
                  ratingType: 'DisHelpful',
                  ratingsList: widget.ratingsList.where((element) => !element.ratingType).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ListBuilder extends StatelessWidget {
  final List<CommentRating> ratingsList;
  final String ratingType;

  _ListBuilder({this.ratingsList, this.ratingType});

  @override
  Widget build(BuildContext context) {
    return ratingsList.length == 0
        ? Container(
            child: Center(
              child: Text('No $ratingType ratings yet'),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(50),
              left: ScreenUtil().setSp(30),
              right: ScreenUtil().setSp(40),
              bottom: ScreenUtil().setSp(10),
            ),
            child: ListView.separated(
              itemCount: ratingsList.length,
              separatorBuilder: (context, pos) => pos == ratingsList.length - 1 ? Container() : Divider(),
              itemBuilder: (context, pos) {
                final author = ratingsList[pos].author;
                final iconData = ratingsList[pos].ratingType ? FontAwesomeIcons.thumbsUp : FontAwesomeIcons.thumbsDown;
                final iconColor = ratingsList[pos].ratingType ? Colors.blueAccent : Colors.redAccent;
                return Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setSp(30),
                  ),
                  child: ListTile(
                    leading: Image.network(author.profilePictureRef ??
                        'https://image.winudf'
                            '.com/v2/image/aG90Z2lybGJhYnkuaG90Z2lybGN1dGUuYmFieWhvdGdpcmxfc2NyZWVuXzBfMTUyMzEwNzg2NF8wNjE/screen-0.jpg?fakeurl=1&type=.jpg'),
                    title: Text('${author.firstName} ${author.lastName}'),
                    trailing: FaIcon(
                      iconData,
                      color: iconColor,
                    ),
                  ),
                );
              },
            ),
          );
  }
}
