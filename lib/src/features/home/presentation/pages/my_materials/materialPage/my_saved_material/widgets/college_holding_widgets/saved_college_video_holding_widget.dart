import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/video_state_provider.dart';

import 'package:provider/provider.dart';

class SavedCollegeVideoHoldingWidget extends StatelessWidget {
  final int pos;

  const SavedCollegeVideoHoldingWidget({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    MySavedVideosStateProvider pdfState = Provider.of<MySavedVideosStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteNames.VIEW_LECTURE_DETAILS,
          arguments: {
            'pos': pos,
            'isVideo': false,
            'state': pdfState.savedVideos[pos],
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        child: Card(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
          child: Container(
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
                      UpperPart(pos: pos),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<MySavedVideosStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.savedVideos[pos].topic,
                          builder: (context, topic, _) => Text(
                            topic,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<MySavedVideosStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.savedVideos[pos].title,
                          builder: (context, title, _) => Text(
                            title.toString(),
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<MySavedVideosStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.savedVideos[pos].description,
                          builder: (context, description, _) => Text(
                            description.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Icon(
                          Icons.picture_as_pdf,
                          size: ScreenUtil().setSp(150),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      SizedBox(child: LowerPart(pos: pos)),
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

// String _reformatDescription(String desc) {
//   var desclist = desc.split('\n');
//   var descStr = '';
//   desclist.forEach((element) => descStr += element.toString().trim() + ' ');
//   return descStr;
// }

class LowerPart extends StatelessWidget {
  final int pos;

  const LowerPart({@required this.pos});

  @override
  Widget build(BuildContext context) {
    MySavedVideosStateProvider savedPDFStateProvider = Provider.of<MySavedVideosStateProvider>(context, listen: false);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Selector<MySavedVideosStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.savedVideos[pos].comments.length,
            builder: (context, commentsCount, _) => Container(
              padding: EdgeInsets.only(
                right: ScreenUtil().setSp(30),
              ),
              //color: Colors.red,
              alignment: Alignment.centerRight,
              child: Text('$commentsCount Comments'),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(50),
          ),
          Selector<MySavedVideosStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.savedVideos[pos].isSaved,
            builder: (context, isSaved, _) => GestureDetector(
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.black,
              ),
              onTap: () async {
                final String text = 'Are You Sure you want to unsave this item';
                final Widget yesButton = RaisedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(true);
                  },
                );

                final Widget noButton = RaisedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop(false);
                  },
                );

                List<Widget> _actions = [
                  yesButton,
                  noButton,
                ];

                Widget dialogWidget = Platform.isAndroid
                    ? AlertDialog(
                  title: Text(text),
                  actions: _actions,
                )
                    : CupertinoAlertDialog(
                  title: Text(text),
                  actions: _actions,
                );
                bool val = await showDialog(
                  useRootNavigator: true,
                  context: context,
                  builder: (context) => dialogWidget,
                );
                if (val) {
                  final String id = savedPDFStateProvider.savedVideos[pos].id;
                  savedPDFStateProvider.removeVideoAt(pos);
                  Provider.of<VideoStateProvider>(context, listen: false).onMaterialSavingFromExternal(id);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class UpperPart extends StatelessWidget {
  final int pos;

  const UpperPart({@required this.pos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Selector<MySavedVideosStateProvider, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.savedVideos[pos].author.firstName,
                  stateProvider.savedVideos[pos].author.lastName,
                ],
                builder: (context, names, _) => Text(
                  names[0] + ' ' + names[1],
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Selector<MySavedVideosStateProvider, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.savedVideos[pos].author.college,
                  stateProvider.savedVideos[pos].author.university,
                ],
                builder: (context, names, _) => Text(
                  names[0] + ' / ' + names[1],
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().setSp(15)),
            child: Column(
              children: <Widget>[
                Selector<MySavedVideosStateProvider, String>(
                  selector: (context, stateProvider) => stateProvider.savedVideos[pos].postDate,
                  builder: (context, postDate, _) => Text(
                    postDate.substring(0, 10),
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                  ),
                ),
                Selector<MySavedVideosStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.savedVideos[pos].stage,
                  builder: (context, stage, _) => Text(
                    'Stage' + stage.toString(),
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
