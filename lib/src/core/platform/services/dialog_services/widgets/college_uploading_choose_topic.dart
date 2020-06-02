import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_state_providers/college_uploads_state_provider.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_uploader_widget.dart';
import 'package:provider/provider.dart';


class CollegeUploadingChooseTopic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CollegeUploadingState collegeUploadingState = Provider.of<CollegeUploadingState>(context, listen: false);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context,listen: false);


    return Selector<CollegeUploadingState, List>(
      selector: (context, stateProvider) => [stateProvider.topicList, stateProvider.topic],
      builder: (context, _, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField(
            items: !_enabled(profilePageState, collegeUploadingState)
                ? null
                : collegeUploadingState.topicList
                .map((item) => DropdownMenuItem(
              child: Text(
                item,
                style: TextStyle(fontSize: ScreenUtil().setSp(37)),
              ),
              value: item,
            ))
                .toList(),
            onChanged: !_enabled(profilePageState, collegeUploadingState)
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

bool _enabled(ProfilePageState profileState, CollegeUploadingState uploadingState) {
  String account_type = profileState.userData.commonFields.account_type;
  String college = profileState.userData.college;
  if (account_type == 'unistudents') {
    return new RegExp(r'سنان').hasMatch(college) || (isPharmacyOrMedicine(profileState) && uploadingState.semester != null);
  } else {
    return ((isPharmacyOrMedicine(profileState) && uploadingState.semester != null) || new RegExp(r'سنان').hasMatch(college)) && uploadingState.stage != null;
  }
}
