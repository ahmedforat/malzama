import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../core/references/references.dart';
import '../../../../../models/materials/school_material.dart';
import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class SchoolPDFHoldingWidget<T extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const SchoolPDFHoldingWidget({@required this.pos});

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
                    Selector<T, String>(
                      selector: (context, stateProvider) => stateProvider.materials[pos].topic,
                      builder: (context, topic, _) => Text(topic),
                    ),
                    Selector<T, List<String>>(
                        selector: (context, stateProvider) => [
                              stateProvider.materials[pos].author.firstName,
                              stateProvider.materials[pos].author.lastName,
                            ],
                        builder: (context, names, _) => Text('اعداد المدرس : ${names[0] + names[1]}')),
                    Selector<T, String>(
                        selector: (context, stateProvider) => stateProvider.materials[pos].author.school,
                        builder: (context, school, _) => Text(school)),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Selector<T, int>(
                      selector: (context, stateProvider) => stateProvider.materials[pos].stage,
                      builder: (context, stage, _) => Text(References.stages[stage]),
                    ),
                    Selector<T, String>(
                        selector: (context, stateProvider) => stateProvider.materials[pos].author.school,
                        builder: (context, school, _) => Text(school)),
                    Selector<T, String>(
                        selector: (context, stateProvider) => (stateProvider.materials[pos] as SchoolMaterial).schoolSection,
                        builder: (context, schoolSection, _) => Text(schoolSection)),
                    Selector<T, String>(
                      selector: (context, stateProvider) => stateProvider.materials[pos].postDate,
                      builder: (context, postDate, _) => Text(postDate.substring(0, 10)),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(30)),
            Selector<T, String>(
              selector: (context, stateProvider) => stateProvider.materials[pos].title,
              builder: (context, title, _) => Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
            Selector<T, String>(
              selector: (context, stateProvider) => stateProvider.materials[pos].description,
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
                Selector<T, int>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].comments.length,
                  builder: (context, commentsCount, _) => Text(' تعليق$commentsCount'),
                ),
                Icon(Icons.picture_as_pdf),
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
                    onTap: () => HelperFucntions.onPdforVideoSaving<T>(context: context,pos:pos),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
