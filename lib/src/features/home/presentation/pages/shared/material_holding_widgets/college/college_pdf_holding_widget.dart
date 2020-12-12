import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/Navigator/routes_names.dart';
import '../../../../../models/materials/study_material.dart';
import '../../../lectures_pages/state/material_state_repo.dart';

class CollegePDFHoldingWidget<T extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const CollegePDFHoldingWidget({
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
                Header<T>(pos),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      // UpperPart<T>(pos: pos),

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
                          Icons.picture_as_pdf,
                          size: ScreenUtil().setSp(150),
                        ),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),

                      Footer<T>(pos: pos)
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

class Header<T extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const Header(this.pos);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    T pdfStateProvider = Provider.of<T>(context, listen: false);
    UserInfoStateProvider userInfoState = locator<UserInfoStateProvider>();
    final bool isMyMaterial = userInfoState.userData.id == pdfStateProvider.materials[pos].author.id;
    final String postDate = pdfStateProvider.materials[pos].postDate.substring(0, 10);
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
              Selector<T, String>(
                selector: (context, T stateProvider) => stateProvider.materials[pos].lastUpdate,
                builder: (context, lastUpdate, _) => lastUpdate != null
                    ? Container()
                    : Text(
                        'Last update: ${postDate}',
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
              Selector<T, String>(
                selector: (context, stateProvider) => stateProvider.materials[pos].topic,
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
          if (isMyMaterial)
            FlatButton(
              onPressed: () {
                HelperFucntions.showEditOrDeleteModalSheet(context: context);
              },
              child: Icon(Icons.edit),
            ),
          if (!isMyMaterial)
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

class Footer<T extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const Footer({@required this.pos});

  @override
  Widget build(BuildContext context) {
    StudyMaterial myState = Provider.of<T>(context, listen: false).materials[pos];
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
