import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/Navigator/routes_names.dart';
import '../../../../models/materials/study_material.dart';
import '../state/pdf_state_provider.dart';

class CollegePDFHoldingWidget extends StatelessWidget {
  final int pos;

  const CollegePDFHoldingWidget({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    PDFStateProvider pdfState = Provider.of<PDFStateProvider>(context, listen: false);
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RouteNames.VIEW_LECTURE,
          arguments: {
            'pos': pos,
            'isVideo': false,
            'state': pdfState.materials[pos],
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
                      UpperPart(pos: pos),
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                        child: Selector<PDFStateProvider, String>(
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
                        child: Selector<PDFStateProvider, String>(
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
                        child: Selector<PDFStateProvider, String>(
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
                      LowerPart(pos: pos),
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

class LowerPart extends StatelessWidget {
  final int pos;

  const LowerPart({@required this.pos});

  @override
  Widget build(BuildContext context) {
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
              PDFStateProvider pdfState = Provider.of<PDFStateProvider>(context, listen: false);
              final routName = RouteNames.VIEW_LECTURE;
              Navigator.of(context).pushNamed(
                routName,
                arguments: {
                  'isVideo': false,
                  'pos': pos,
                  'addComment': true,
                  'commentIds': pdfState.materials[pos].comments,
                },
              );
            },
          ),
          Expanded(
            child: Selector<PDFStateProvider, int>(
              selector: (context, stateProvider) => stateProvider.materials[pos].comments.length,
              builder: (context, commentsCount, _) => Container(
                padding: EdgeInsets.only(
                  right: ScreenUtil().setSp(30),
                ),
                //color: Colors.red,
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text('$commentsCount Comments'),
              ),
            ),
          ),
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
    StudyMaterial myState = Provider.of<PDFStateProvider>(context, listen: false).materials[pos];
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Selector<PDFStateProvider, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.materials[pos].author.firstName,
                  stateProvider.materials[pos].author.lastName,
                ],
                builder: (context, names, _) => Text(
                  names[0] + ' ' + names[1],
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Selector<PDFStateProvider, List<String>>(
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
                Selector<PDFStateProvider, String>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].postDate,
                  builder: (context, postDate, _) => Text(
                    postDate.substring(0, 10),
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                  ),
                ),
                Selector<PDFStateProvider, int>(
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
