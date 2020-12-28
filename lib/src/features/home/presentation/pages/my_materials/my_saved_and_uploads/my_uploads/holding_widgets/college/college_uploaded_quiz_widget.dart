import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_uploads/state_provider/my_uploads_state_provider.dart';
import 'package:provider/provider.dart';

class CollegeUploadedQuizHoldingWidget extends StatelessWidget {
  final int pos;
  final bool fromLocal;

  CollegeUploadedQuizHoldingWidget({
    @required this.pos,
    bool fromLocal,
  }) : this.fromLocal = fromLocal ?? false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MyUploadsStateProvider myUploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        Map<String, dynamic> args = {
          'data': myUploadsStateProvider.uploadedQuizes[pos],
          'fromLocal': fromLocal,
        };
        Navigator.of(context).pushNamed(RouteNames.TAKE_QUIZ_EXAM, arguments: args);
      },
      child: Card(
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30)),
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderWidget(pos),
              _DescriptionWidget(pos),
              Divider(),
              _UploadedQuizFooter(pos: pos),
            ],
          ),
        ),
      ),
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  final int pos;

  const _DescriptionWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setSp(40),
        left: ScreenUtil().setSp(30),
      ),
      child: Selector<MyUploadsStateProvider, String>(
        selector: (_, stateProvider) => stateProvider.uploadedQuizes[pos].credentials.description,
        builder: (_, description, __) => Text(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
          ),
        ),
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  final int pos;

  const _HeaderWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    MyUploadsStateProvider myUploadsStateProvider = Provider.of<MyUploadsStateProvider>(context, listen: false);

    void _onEditOption(BuildContext context) async {
      print('just beofore Navigation to edit quiz');
      await Future.delayed(Duration(milliseconds: 230));
      myUploadsStateProvider.onQuizEdit(context, pos);
    }

    void _onDeleteOption(BuildContext context) async {
      myUploadsStateProvider.onQuizDelete(context, pos);
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setSp(10),
                  left: ScreenUtil().setSp(60),
                ),
                child: Selector<MyUploadsStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.uploadedQuizes[pos].questionsCount,
                  builder: (_, count, __) => Text(
                    '$count questions',
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  final String action = await HelperFucntions.showEditOrDeleteModalSheet(
                    context: context,
                  );
                  if (action == null) {
                    print('the action is $action');
                    return;
                  }
                  if (action == 'edit') {
                    _onEditOption(context);
                  }
                  _onDeleteOption(context);
                },
                child: Icon(Icons.edit),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(30),
              left: ScreenUtil().setSp(30),
            ),
            child: Selector<MyUploadsStateProvider, String>(
              selector: (context, stateProvider) => stateProvider.uploadedQuizes[pos].credentials.title,
              builder: (_, title, __) => Text(
                title ?? 'Unavailable',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenUtil().setSp(15),
              left: ScreenUtil().setSp(80),
            ),
            child: Text('Published in: ' + myUploadsStateProvider.uploadedQuizes[pos].postDate.substring(0, 10).toString()),
          ),
          if (myUploadsStateProvider.uploadedQuizes[pos].lastUpdate != null)
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setSp(6),
                left: ScreenUtil().setSp(80),
              ),
              child: Selector<MyUploadsStateProvider, String>(
                selector: (_, stateProvider) => stateProvider.uploadedQuizes[pos].lastUpdate,
                builder: (_, lastUpdate, __) => Text('Last update:${lastUpdate.substring(0, 10)}'),
              ),
            ),
        ],
      ),
    );
  }
}

class _UploadedQuizFooter extends StatelessWidget {
  final int pos;

  const _UploadedQuizFooter({@required this.pos});

  @override
  Widget build(BuildContext context) {
    final String semester =
        (Provider.of<MyUploadsStateProvider>(context, listen: false).uploadedLectures[pos] as CollegeMaterial).semester.toString();

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
                    stateProvider.uploadedLectures[pos].author.college,
                    stateProvider.uploadedLectures[pos].author.university,
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
                    selector: (context, stateProvider) => stateProvider.uploadedLectures[pos].stage,
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
                      selector: (context, stateProvider) => (stateProvider.uploadedLectures[pos] as CollegeMaterial).semester,
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
