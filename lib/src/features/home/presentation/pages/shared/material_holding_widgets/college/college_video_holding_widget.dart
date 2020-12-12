import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/Navigator/routes_names.dart';
import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../lectures_pages/state/material_state_repo.dart';

class CollegeVideoHoldingWidget<T extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const CollegeVideoHoldingWidget({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteNames.VIEW_VIDEO_DETAILS, arguments: pos);
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
                      UpperPart<T>(pos: pos),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<T, String>(
                          selector: (context, stateProvider) => stateProvider.materials[pos].topic,
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
                        child: Selector<T, String>(
                          selector: (context, stateProvider) => stateProvider.materials[pos].title,
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
                        child: Selector<T, String>(
                          selector: (context, stateProvider) => stateProvider.materials[pos].description,
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
                          Icons.video_collection_rounded,
                          size: ScreenUtil().setSp(150),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      LowerPart<T>(pos: pos),
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

class LowerPart<T extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const LowerPart({@required this.pos});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Selector<T, int>(
            selector: (context, stateProvider) => stateProvider.materials[pos].comments.length,
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
          Selector<T, bool>(
            selector: (context, stateProvider) => stateProvider.materials[pos].isSaved,
            builder: (context, isSaved, _) => GestureDetector(
              child: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.black,
              ),
              onTap: () => HelperFucntions.onPdforVideoSaving<T>(context: context, pos: pos),
            ),
          )
        ],
      ),
    );
  }
}

class UpperPart<T extends MaterialStateRepository> extends StatelessWidget {
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
              Selector<T, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.materials[pos].author.firstName,
                  stateProvider.materials[pos].author.lastName,
                ],
                builder: (context, names, _) => Text(
                  names[0] + ' ' + names[1],
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Selector<T, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.materials[pos].author.college,
                  stateProvider.materials[pos].author.university,
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
                Selector<T, String>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].postDate,
                  builder: (context, postDate, _) => Text(
                    postDate.substring(0, 10),
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                  ),
                ),
                Selector<T, int>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].stage,
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
