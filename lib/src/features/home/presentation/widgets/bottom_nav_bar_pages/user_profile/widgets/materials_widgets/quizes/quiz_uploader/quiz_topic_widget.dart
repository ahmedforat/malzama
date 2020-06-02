import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../core/references/references.dart';
import '../../../../../../../state_provider/profile_page_state_provider.dart';
import '../../../../../../../state_provider/quiz_uploading_state_provider.dart';

class QuizTopicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState pageState = Provider.of<ProfilePageState>(context, listen: false);

    // print(pageState.userData.stage.runtimeType);
    QuizUploadingState uploadingState = Provider.of<QuizUploadingState>(context, listen: false);

    return Selector<QuizUploadingState, List>(
      selector: (context, stateProvider) => [stateProvider.topicList, stateProvider.topic],
      builder: (context, _, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            items: !_enabled(pageState, uploadingState)
                ? null
                : uploadingState.topicList
                    .map((item) => DropdownMenuItem(
                          child: Text(
                            item,
                            style: TextStyle(fontSize: ScreenUtil().setSp(37)),
                          ),
                          value: item,
                        ))
                    .toList(),
            onChanged: !_enabled(pageState, uploadingState)
                ? null
                : (val) {
                    uploadingState.updateTopic(val);
                  },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'this field is required';
              }
              return null;
            },
            value: uploadingState.topic,
            hint: Text('Choose topic'),
          ),
        ),
      ),
    );
  }
}

bool _enabled(ProfilePageState profileState, QuizUploadingState uploadingState) {
  String account_type = profileState.userData.commonFields.account_type;
  String college = profileState.userData.college;
  if (account_type == 'unistudents') {
    return new RegExp(r'سنان').hasMatch(college) || (isPharmacyOrMedicine(profileState) && uploadingState.semester != null);
  } else {
    return ((isPharmacyOrMedicine(profileState) && uploadingState.semester != null) || new RegExp(r'سنان').hasMatch(college)) && uploadingState.stage != null;
  }
}
