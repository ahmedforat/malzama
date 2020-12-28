import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../../models/materials/school_material.dart';
import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class SchoolQuizHoldingWidget<T extends QuizStateRepository> extends StatelessWidget {
  final int pos;
  final bool fromLocal;

  const SchoolQuizHoldingWidget({
    @required this.pos,
    bool fromLocal,
  }) : this.fromLocal = fromLocal ?? false;

  @override
  Widget build(BuildContext context) {
    T quizStateProvider = Provider.of<T>(context, listen: false);
    ScreenUtil.init(context);
    return InkWell(
      onTap: () {
        Map<String, dynamic> args = {
          'data': quizStateProvider.materials[pos],
          'fromLocal': fromLocal,
        };
        Navigator.of(context).pushNamed(RouteNames.TAKE_QUIZ_EXAM, arguments: args);
      },
      child: Container(
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
                        selector: (context, stateProvider) => stateProvider.materials[pos].credentials.topic,
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
                        selector: (context, stateProvider) => int.parse(stateProvider.materials[pos].credentials.stage),
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
                selector: (context, stateProvider) => stateProvider.materials[pos].credentials.title,
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
                selector: (context, stateProvider) => stateProvider.materials[pos].credentials.description,
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
            ],
          ),
        ),
      ),
    );
  }
}
