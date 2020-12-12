import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../models/materials/college_material.dart';
import '../../../lectures_pages/state/material_state_repo.dart';

class CollegeMaterialDetailsAuthorWidget<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const CollegeMaterialDetailsAuthorWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    MaterialStateRepository materialStateRepo = Provider.of<B>(context, listen: false);
    ScreenUtil.init(context);
    return Container(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Selector<B, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.materials[pos].author.firstName,
                  stateProvider.materials[pos].author.lastName,
                ],
                builder: (context, data, _) => Text('By ${data.first} ${data.last}'),
              ),
              if (HelperFucntions.isTeacher(materialStateRepo.materials[pos].author.accountType))
                Selector<B, String>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].author.speciality,
                  builder: (context, speciality, _) => Text('$speciality'),
                ),
              Selector<B, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.materials[pos].author.university,
                  stateProvider.materials[pos].author.college,
                ],
                builder: (context, data, _) => Text('${data.first} / ${data.last}'),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Selector<B, int>(
                selector: (context, stateProvider) => stateProvider.materials[pos].stage,
                builder: (context, stage, _) => Text('Stage $stage'),
              ),
              if (false || (Provider.of<B>(context, listen: false).materials[pos] as CollegeMaterial)?.semester != null)
                Selector<B, int>(
                  selector: (context, stateProvider) => (stateProvider.materials[pos] as CollegeMaterial).semester,
                  builder: (context, semester, _) => Text('Semester $semester'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
