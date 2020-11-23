import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../../../../models/users/college_user.dart';
import '../../../../../../state_provider/user_info_provider.dart';
import '../../state_providers/college_uploads_state_provider.dart';

class CollegeChooseTopicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CollegeUploadingState collegeUploadingState = Provider.of<CollegeUploadingState>(context, listen: false);
    print('this is the college uploading state');
    print(collegeUploadingState);
    print('this is the college uploading state');

    return Selector<CollegeUploadingState, List<dynamic>>(
      selector: (context, stateProvider) => [
        stateProvider.topic,
        stateProvider.semester,
        stateProvider.stage,
      ],
      builder: (context, _, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(5)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            items: !_enabled(collegeUploadingState)
                ? null
                : collegeUploadingState.topicList
                    .map((item) => DropdownMenuItem(
                          child: Text(
                            item,
                            style: TextStyle(fontSize: ScreenUtil().setSp(28)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          value: item,
                        ))
                    .toList(),
            onChanged: !_enabled(collegeUploadingState)
                ? null
                : (val) {
                    collegeUploadingState.updateLectureTopic(val);
                  },
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'this field is required';
              }
              return null;
            },
            value: collegeUploadingState.topic,
            hint: Text('Choose topic'),
          ),
        ),
      ),
    );
  }
}

bool _enabled(CollegeUploadingState uploadingState) {
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
