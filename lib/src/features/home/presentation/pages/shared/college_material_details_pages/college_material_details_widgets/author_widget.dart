import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class CollegeMaterialDetailsAuthorWidget<B extends MaterialStateRepo> extends StatelessWidget {
  final int pos;

  const CollegeMaterialDetailsAuthorWidget(this.pos);

  @override
  Widget build(BuildContext context) {
    MaterialStateRepo materialStateRepo = Provider.of<B>(context,listen: false);
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
               Text('By Proof Asis Dhiaa Jabbar') ??Selector<B, List<String>>(
                selector: (context, stateProvider) => [
                  stateProvider.materials[pos].author.firstName,
                  stateProvider.materials[pos].author.lastName,
                ],
                builder: (context, data, _) => Text('By ${data.first} ${data.last}'),
              ),
              if(false)
              if (HelperFucntions.isTeacher(materialStateRepo.materials[pos].author.accountType))
                Text('Clinical Pharmacy and Therapeutics') ??Selector<B, String>(
                  selector: (context, stateProvider) => stateProvider.materials[pos].author.speciality,
                  builder: (context, speciality, _) => Text('$speciality'),
                ),
              Text('College of Pharmacy \nBaghdad University')?? Selector<B, List<String>>(
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
              Text('Stage 3') ?? Selector<B, int>(
                selector: (context, stateProvider) => stateProvider.materials[pos].stage,
                builder: (context, stage, _) => Text('Stage $stage'),
              ),
        Text('semester 3'),
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
    );
  }
}
