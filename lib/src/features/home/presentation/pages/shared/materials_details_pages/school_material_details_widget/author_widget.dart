import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../models/materials/college_material.dart';
import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';

class SchoolMaterialDetailsAuthorWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const SchoolMaterialDetailsAuthorWidget(this.pos);

  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        //height: ScreenUtil().setSp(300),
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('الكيمياء') ??
                      Selector<B, String>(
                        selector: (context, stateProvider) => stateProvider.materials[pos].author.speciality,
                        builder: (context, speciality, _) => Text('$speciality'),
                      ),
                  Text('اعداد الاستاذ: ماجد محمد الركابي') ??
                      Selector<B, List<String>>(
                        selector: (context, stateProvider) => [
                          stateProvider.materials[pos].author.firstName,
                          stateProvider.materials[pos].author.lastName,
                        ],
                        builder: (context, data, _) => Text('By ${data.first} ${data.last} اعداد المدرس '),
                      ),
                  //if (HelperFucntions.isTeacher(materialStateRepo.materials[pos].author.accountType))

                  Text('اعدادية الانصار للبنين') ??
                      Selector<B, List<dynamic>>(
                        selector: (context, stateProvider) => [
                          stateProvider.materials[pos].author.school,
                          stateProvider.materials[pos].author.schoolSection,
                          stateProvider.materials[pos].stage,
                        ],
                        builder: (context, data, _) => Text('${data.first} / ${data.last}'),
                      ),

                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Text('السادس الاعدادي') ??
                    Selector<B, int>(
                      selector: (context, stateProvider) => stateProvider.materials[pos].stage,
                      builder: (context, stage, _) => Text('Stage $stage'),
                    ),
                Text('الفرع الاحيائي والتطبيقي'),
                if(false)
                  if (false || (locator<B>().materials[pos] as CollegeMaterial)?.semester != null)
                    Selector<B, int>(
                      selector: (context, stateProvider) => (stateProvider.materials[pos] as CollegeMaterial).semester,
                      builder: (context, semester, _) => Text('Stage $semester'),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
