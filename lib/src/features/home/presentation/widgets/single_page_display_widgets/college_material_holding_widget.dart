import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/custom_selector.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../core/Navigator/routes_names.dart';

class CollegeMaterialHoldingWidget extends StatelessWidget {
  final int pos;
  final state;
  final String materialType;
  List<String> topic;

  CollegeMaterialHoldingWidget({
    @required this.pos,
    @required this.state,
    this.materialType,
  }) {
    topic = materialType == 'video'
        ? state.videos[pos].topic.toString().split(' ').toList()
        : state.myPDFS[pos].topic.toString().split(' ').toList();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context,listen: false);
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          materialType == 'video' ? RouteNames.VIEW_VIDEO : RouteNames.VIEW_LECTURE,
          arguments: {
            'pos': pos,
            'isVideo': materialType == 'video',
            'state': materialType == 'video' ? state.videos[pos] : state.myPDFS[pos],
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        child: Card(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
          child: Container(
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: pos % 2 == 0 ? [Colors.redAccent,Colors.redAccent.withOpacity(0.7)]:[Colors.blueAccent,Colors.blueAccent.withOpacity(0.7)]
//              )
//            ),
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setSp(30),
              ScreenUtil().setSp(30),
              ScreenUtil().setSp(30),
              0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(ScreenUtil().setSp(15)),
//                    child: Text('Ph Asistant Dhiaa Jabbar'),
//                  ),
                      _buildUpperPart(materialType, pos, state),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Text(
                          materialType == 'video' ? state.videos[pos].topic.toString() : state.myPDFS[pos].topic.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Text(
                          materialType == 'video' ? state.videos[pos].title.toString() : state.myPDFS[pos].title.toString(),
                          style: TextStyle(fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Text(
                          materialType == 'video'
                              ? _reformatDescription(state.videos[pos].description.toString())
                              : _reformatDescription(state.myPDFS[pos].description.toString()),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Icon(
                          materialType == 'video' ? Icons.video_library : Icons.picture_as_pdf,
                          size: ScreenUtil().setSp(150),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      _buildLowerPart(context, materialType, pos, state,userInfoStateProvider.account_type)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _reformatDescription(String desc) {
  var desclist = desc.split('\n');
  var descStr = '';
  desclist.forEach((element) => descStr += element.toString().trim() + ' ');
  return descStr;
}

Widget _buildLowerPart(BuildContext context, String materialType, int pos, state,String account_type) {
  return Container(
    child: Row(
      children: <Widget>[
        MaterialButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Add Comment'),
              SizedBox(
                width: ScreenUtil().setWidth(20),
              ),
              Icon(Icons.comment),
            ],
          ),
          onPressed: () {
            final routName = materialType == 'video' ? RouteNames.VIEW_VIDEO : RouteNames.VIEW_LECTURE;
            Navigator.of(context).pushNamed(
              routName,
              arguments: {
                'isVideo': materialType == 'video',
                'pos': pos,
                'addComment': true,
                'commentIds': materialType == 'video' ? state.videos[pos].comments : state.myPDFS[pos].comments,
              },
            );
          },
        ),
        Expanded(
          child: CustomHomePageSelectorWidget<int>(
            isAcademic: HelperFucntions.isAcademic(account_type),
            selector: (context, stateProvider) => stateProvider.materialItems[pos].comments.length,
            builder: (context, commentsCount, _) => Container(
              padding: EdgeInsets.only(right: ScreenUtil().setSp(30)),
              //color: Colors.red,
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: Text('$commentsCount Comments'),
            ) ,
          ),
        ),
      ],
    ),
  );
}

Widget _buildUpperPart(String materialType, int pos, state) {
  return Padding(
    padding: EdgeInsets.all(ScreenUtil().setSp(15)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              materialType == 'video'
                  ? state.videos[pos].author['firstName'] + ' ' + state.videos[pos].author['lastName']
                  : state.myPDFS[pos].author['firstName'] + ' ' + state.myPDFS[pos].author['lastName'],
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
            ),
            Text(
              materialType == 'video'
                  ? state.videos[pos].university + ' / ' + state.videos[pos].college
                  : state.myPDFS[pos].university + ' / ' + state.myPDFS[pos].college,
              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
            ),

//                            Text(
//                              'Stage 1',
//                              style: TextStyle(fontSize: ScreenUtil().setSp(30)),
//                            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setSp(15)),
          child: Column(
            children: <Widget>[
              Text(
                materialType == 'video'
                    ? state.videos[pos].post_date.toString().substring(0, 10)
                    : state.myPDFS[pos].post_date.toString().substring(0, 10),
                style: TextStyle(fontSize: ScreenUtil().setSp(35)),
              ),
              Text(
                'Stage' + (materialType == 'video' ? state.videos[pos].stage : state.myPDFS[pos].stage).toString(),
                style: TextStyle(fontSize: ScreenUtil().setSp(35), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget commentSection(bool addComment) => Container(
      //color: Colors.red,
      padding: EdgeInsets.only(
        left: ScreenUtil().setSp(15),
        top: ScreenUtil().setSp(20),
        right: ScreenUtil().setSp(10),
        bottom: ScreenUtil().setSp(10),
      ),
      child: Row(
        children: <Widget>[
          userAvatar(),
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(400), minHeight: ScreenUtil().setHeight(80)),
              //height: ScreenUtil().setHeight(100),
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(10)),
              child: TextField(
                maxLines: null,
                maxLength: null,
                minLines: null,
                autofocus: addComment,
                // textAlign: TextAlign.start,
                //textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Add comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      ScreenUtil().setSp(40),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          )
        ],
      ),
    );

Widget userAvatar({String imageUrl}) => Container(
      width: ScreenUtil().setWidth(110),
      height: ScreenUtil().setHeight(110),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(55)),
        image: DecorationImage(
          image: imageUrl != null ? NetworkImage(imageUrl) : AssetImage('assets/kaka.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
