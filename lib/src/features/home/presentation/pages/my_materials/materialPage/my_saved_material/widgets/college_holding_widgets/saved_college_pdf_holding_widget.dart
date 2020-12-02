import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_pdf_state_provider.dart';

import 'package:provider/provider.dart';

class SavedCollegePDFHoldingWidget extends StatelessWidget {
  final int pos;

  const SavedCollegePDFHoldingWidget({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    MySavedPDFStateProvider pdfState = Provider.of<MySavedPDFStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteNames.VIEW_LECTURE_DETAILS,
          arguments: {
            'pos': pos,
            'isVideo': false,
            'state': pdfState.savedLectures[pos],
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
                        child: Selector<MySavedPDFStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.savedLectures[pos].topic,
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
                        child: Selector<MySavedPDFStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.savedLectures[pos].title,
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
                        child: Selector<MySavedPDFStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.savedLectures[pos].description,
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
    MySavedPDFStateProvider savedPDFStateProvider = Provider.of<MySavedPDFStateProvider>(context, listen: false);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Selector<MySavedPDFStateProvider, int>(
            selector: (context, stateProvider) => stateProvider.savedLectures[pos].comments.length,
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
          Selector<MySavedPDFStateProvider, bool>(
            selector: (context, stateProvider) => stateProvider.savedLectures[pos].isSaved,
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
                  final String id = savedPDFStateProvider.savedLectures[pos].id;
                  savedPDFStateProvider.removeLectureAt(pos);
                  Provider.of<PDFStateProvider>(context, listen: false).onMaterialSavingFromExternal(id);
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
              Selector<MySavedPDFStateProvider, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.savedLectures[pos].author.firstName,
                  stateProvider.savedLectures[pos].author.lastName,
                ],
                builder: (context, names, _) => Text(
                  names[0] + ' ' + names[1],
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Selector<MySavedPDFStateProvider, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.savedLectures[pos].author.college,
                  stateProvider.savedLectures[pos].author.university,
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
                Selector<MySavedPDFStateProvider, String>(
                  selector: (context, stateProvider) => stateProvider.savedLectures[pos].postDate,
                  builder: (context, postDate, _) => Text(
                    postDate.substring(0, 10),
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                  ),
                ),
                Selector<MySavedPDFStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.savedLectures[pos].stage,
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
