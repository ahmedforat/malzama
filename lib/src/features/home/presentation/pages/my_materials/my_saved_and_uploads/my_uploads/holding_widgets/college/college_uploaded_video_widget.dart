import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:provider/provider.dart';

class CollegeUploadedVideoHoldingWidget extends StatelessWidget {
  final int pos;

  const CollegeUploadedVideoHoldingWidget({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MyUploadsStateProvider myUploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
    final String postDate = myUploadsStateProvider.uploadedVideos[pos].postDate.substring(0, 10);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Published in: $postDate',
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: ScreenUtil().setSp(27),
                                ),
                              ),
                              Selector<MyUploadsStateProvider, String>(
                                selector: (context, stateProvider) => stateProvider.uploadedVideos[pos].lastUpdate,
                                builder: (context, lastUpdate, _) => lastUpdate == null
                                    ? Container()
                                    : Text(
                                        'Last update: ${lastUpdate.substring(0, 10)}',
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: ScreenUtil().setSp(27),
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Selector<MyUploadsStateProvider, String>(
                                selector: (context, stateProvider) => stateProvider.uploadedVideos[pos].topic,
                                builder: (context, topic, _) => Text(
                                  topic,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    fontSize: ScreenUtil().setSp(37),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          FlatButton(
                            onPressed: () async {
                              final String val = await HelperFucntions.showEditOrDeleteModalSheet(context: context);
                              if (val == null) return;

                              val == 'edit'
                                  ? myUploadsStateProvider.onMaterialEdit(context, pos, true)
                                  : myUploadsStateProvider.onMaterialDelete(context, pos, 'videos');
                            },
                            child: Icon(Icons.edit),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<MyUploadsStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.uploadedVideos[pos].title,
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
                        child: Selector<MyUploadsStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.uploadedVideos[pos].description,
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
                      Divider(),
                      _Footer(pos: pos),
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

class _Footer extends StatelessWidget {
  final int pos;

  const _Footer({@required this.pos});

  @override
  Widget build(BuildContext context) {
    final String semester =
        (Provider.of<MyUploadsStateProvider>(context, listen: false).uploadedVideos[pos] as CollegeMaterial).semester.toString();

    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Selector<MyUploadsStateProvider, List<String>>(
                    selector: (context, stateProvider) => [
                          stateProvider.uploadedVideos[pos].author.firstName,
                          stateProvider.uploadedVideos[pos].author.lastName,
                        ],
                    builder: (context, names, _) {
                      String text = names.first + ' ' + names.last + ' abdulKareem alsudanie';
                      final int endIndex = text.length >= 40 ? 40 : text.length;
                      text = text.substring(0, endIndex);
                      return Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                Selector<MyUploadsStateProvider, List<String>>(
                  selector: (context, stateProvider) => [
                    stateProvider.uploadedVideos[pos].author.college,
                    stateProvider.uploadedVideos[pos].author.university,
                  ],
                  builder: (context, names, _) {
                    String text = names.first + ' / ' + names.last;
                    final int endIndex = text.length >= 40 ? 40 : text.length;
                    text = text.substring(0, endIndex);
                    return Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              color: Colors.grey,
              width: ScreenUtil().setWidth(1),
            ),
            Padding(
              padding: EdgeInsets.only(right: ScreenUtil().setSp(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Selector<MyUploadsStateProvider, int>(
                    selector: (context, stateProvider) => stateProvider.uploadedVideos[pos].stage,
                    builder: (context, stage, _) => Text(
                      'Stage $stage',
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (semester != 'unknown')
                    Selector<MyUploadsStateProvider, int>(
                      selector: (context, stateProvider) => (stateProvider.uploadedVideos[pos] as CollegeMaterial).semester,
                      builder: (context, semester, _) => Text(
                        'Semester $semester',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
