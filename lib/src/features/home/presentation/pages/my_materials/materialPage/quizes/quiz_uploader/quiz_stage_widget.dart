import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/models/users/college_user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploader_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/references/references.dart';
import '../../../../../state_provider/profile_page_state_provider.dart';

class QuizStageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizUploaderState uploadingState = Provider.of<QuizUploaderState>(context, listen: false);

    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);
    return Selector<QuizUploaderState, int>(
      selector: (context, stateProvider) => stateProvider.stage,
      builder: (context, _, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<int>(
            items: _getProperList()
                .map((item) => DropdownMenuItem(
                      child: Text(item.value),
                      value: int.parse(item.key),
                    ))
                .toList(),
            onChanged: uploadingState.updateStage,
            value: uploadingState.stage,
            hint: Text('Choose stage'),
            validator: (val) {
              return val == null ? 'this Field is required' : null;
            },
          ),
        ),
      ),
    );
  }
}

List<MapEntry> _getProperList() {
  String college = (locator<UserInfoStateProvider>().userData as CollegeUser).college;
  if (new RegExp(r'صيدلة|سنان').hasMatch(college)) {
    return References.stagesMapper.entries.toList().sublist(0, 5);
  } else if (new RegExp(r'مرضية').hasMatch(college)) {
    return References.stagesMapper.entries.toList().sublist(0, 4);
  } else {
    return References.stagesMapper.entries.toList();
  }
}
