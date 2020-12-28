import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/models/materials/school_material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:provider/provider.dart';

class SchoolUploadedPDFHoldingWidget extends StatelessWidget {
  final int pos;

  const SchoolUploadedPDFHoldingWidget({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteNames.VIEW_LECTURE_DETAILS,
          arguments: pos,
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
                Header(pos),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // UpperPart<T>(pos: pos),

                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<MyUploadsStateProvider, String>(
                          selector: (context, stateProvider) => stateProvider.uploadedLectures[pos].title,
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
                          selector: (context, stateProvider) => stateProvider.uploadedLectures[pos].description,
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
                      Divider(),
                      _Footer(pos: pos)
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

class Header extends StatelessWidget {
  final int pos;

  const Header(this.pos);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MyUploadsStateProvider myUploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
    final String postDate = myUploadsStateProvider.uploadedLectures[pos].postDate.substring(0, 10);
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
      child: Row(
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
                selector: (context, stateProvider) => stateProvider.uploadedLectures[pos].lastUpdate,
                builder: (context, lastUpdate, _) => lastUpdate == null
                    ? Container()
                    : Text(
                        'Last update: $lastUpdate',
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
                selector: (context, stateProvider) => stateProvider.uploadedLectures[pos].topic,
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
                  ? myUploadsStateProvider.onMaterialEdit(context, pos, false)
                  : myUploadsStateProvider.onMaterialDelete(context, pos, 'lectures');
            },
            child: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final int pos;

  const _Footer({@required this.pos});

  @override
  Widget build(BuildContext context) {
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
                          stateProvider.uploadedLectures[pos].author.firstName,
                          stateProvider.uploadedLectures[pos].author.lastName,
                        ],
                    builder: (context, names, _) {
                      String text = names.first + ' ' + names.last;
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
                Selector<MyUploadsStateProvider, String>(
                  selector: (context, stateProvider) => (stateProvider.uploadedLectures[pos] as SchoolMaterial).school,
                  builder: (context, school, _) {
                    String text = school;
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
                    selector: (context, stateProvider) => stateProvider.uploadedLectures[pos].stage,
                    builder: (context, stage, _) => Text(
                      References.stages[stage],
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Selector<MyUploadsStateProvider, String>(
                    selector: (context, stateProvider) => (stateProvider.uploadedLectures[pos] as SchoolMaterial).schoolSection,
                    builder: (context, schoolSection, _) => Text(
                      schoolSection,
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
