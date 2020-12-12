import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../models/users/college_user.dart';
import '../../../../../state_provider/quiz_uploader_state_provider.dart';
import '../../../../../state_provider/user_info_provider.dart';

class QuizTopicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    // print(pageState.userData.stage.runtimeType);
    QuizUploaderState uploadingState = Provider.of<QuizUploaderState>(context, listen: false);

    return Selector<QuizUploaderState, List>(
      selector: (context, stateProvider) => [stateProvider.topicList, stateProvider.topic],
      builder: (context, _, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            items: !_enabled(uploadingState)
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
            onChanged: !_enabled(uploadingState)
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

bool _enabled(QuizUploaderState uploadingState) {
  UserInfoStateProvider userInfoStateProvider = locator<UserInfoStateProvider>();
  String accountType = userInfoStateProvider.userData.accountType;
  String college = (userInfoStateProvider.userData as CollegeUser).college;
  if (accountType == 'unistudents') {
    return new RegExp(r'سنان').hasMatch(college) || (HelperFucntions.isPharmacyOrMedicine() && uploadingState.semester != null);
  } else {
    return ((HelperFucntions.isPharmacyOrMedicine() && uploadingState.semester != null) || new RegExp(r'سنان').hasMatch(college)) &&
        uploadingState.stage != null;
  }
}
