import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../core/references/references.dart';
import '../../../../../state_provider/profile_page_state_provider.dart';
import '../../../../../state_provider/quiz_uploading_state_provider.dart';



class QuizStageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizUploadingState uploadingState =
    Provider.of<QuizUploadingState>(context, listen: false);

    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context,listen: false);
    return Selector<QuizUploadingState, int>(
      selector: (context, stateProvider) =>stateProvider.stage,
      builder: (context, _, __) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<int>(
            items: _getProperList(profilePageState)
                .map((item) => DropdownMenuItem(
              child: Text(item.value),
              value: int.parse(item.key),
            ))
                .toList(),
            onChanged: uploadingState.updateStage,
            value: uploadingState.stage,
            hint: Text('Choose stage'),
            validator: (val){
              return val == null ? 'this Field is required':null;
            },
          ),
        ),
      ),
    );
  }
}


List<MapEntry> _getProperList(ProfilePageState profilePageState){
  String college = profilePageState.userData.college;
  if(new RegExp(r'صيدلة|سنان').hasMatch(college)){
    return References.stagesMapper.entries.toList().sublist(0,5);
  }else if(new RegExp(r'مرضية').hasMatch(college)){
    return References.stagesMapper.entries.toList().sublist(0,4);
  }else{
    return  References.stagesMapper.entries.toList();
  }
}
