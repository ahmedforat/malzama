import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/models/materials/school_material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/my_saved_material/state_provider/saved_pdf_state_provider.dart';

import 'package:provider/provider.dart';

class SavedSchoolPDFHoldingWidget extends StatelessWidget {
  final int pos;

  const SavedSchoolPDFHoldingWidget({@required this.pos});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      //color: Colors.w,
      padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selector<MySavedPDFStateProvider, String>(
                      selector: (context, stateProvider) => stateProvider.savedLectures[pos].topic,
                      builder: (context, topic, _) => Text(topic),
                    ),
                    Selector<MySavedPDFStateProvider, List<String>>(
                        selector: (context, stateProvider) => [
                              stateProvider.savedLectures[pos].author.firstName,
                              stateProvider.savedLectures[pos].author.lastName,
                            ],
                        builder: (context, names, _) => Text('اعداد المدرس : ${names[0] + names[1]}')),
                    Selector<MySavedPDFStateProvider, String>(
                        selector: (context, stateProvider) => stateProvider.savedLectures[pos].author.school,
                        builder: (context, school, _) => Text(school)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selector<MySavedPDFStateProvider, int>(
                      selector: (context, stateProvider) => stateProvider.savedLectures[pos].stage,
                      builder: (context, stage, _) => Text(References.stages[stage]),
                    ),
                    Selector<MySavedPDFStateProvider, String>(
                        selector: (context, stateProvider) => stateProvider.savedLectures[pos].author.school,
                        builder: (context, school, _) => Text(school)),
                    Selector<MySavedPDFStateProvider, String>(
                        selector: (context, stateProvider) => (stateProvider.savedLectures[pos] as SchoolMaterial).schoolSection,
                        builder: (context, schoolSection, _) => Text(schoolSection)),
                    Selector<MySavedPDFStateProvider, String>(
                      selector: (context, stateProvider) => stateProvider.savedLectures[pos].postDate,
                      builder: (context, postDate, _) => Text(postDate.substring(0, 10)),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Selector<MySavedPDFStateProvider, String>(
              selector: (context, stateProvider) => stateProvider.savedLectures[pos].title,
              builder: (context, title, _) => Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
            Selector<MySavedPDFStateProvider, String>(
              selector: (context, stateProvider) => stateProvider.savedLectures[pos].description,
              builder: (context, description, _) => Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Selector<MySavedPDFStateProvider, int>(
                  selector: (context, stateProvider) => stateProvider.savedLectures[pos].comments.length,
                  builder: (context, commentsCount, _) => Text(' تعليق$commentsCount'),
                ),
                Icon(Icons.picture_as_pdf),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
