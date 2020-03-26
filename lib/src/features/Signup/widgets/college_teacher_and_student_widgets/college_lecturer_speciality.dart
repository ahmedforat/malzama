import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/state_provider/college_post_signup_state.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'package:provider/provider.dart';

class CollegeLecturerSpecialityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollegePostSignUpState collegeState = Provider.of<CollegePostSignUpState>(context,listen:false);
    ScreenUtil.init(context);


    print("sepciality controller is ${collegeState.speciality}");


    return Selector<CollegePostSignUpState,List<String>>(
      selector: (context,stateObject) => [stateObject.errorMessage,stateObject.speciality],
      builder:(context,_,__) => Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),

        child: TextField(
          decoration: InputDecoration(
            errorText: collegeState.errorMessage,
            labelText: 'your speciality',
          ),
          onSubmitted: (String value){
            if(value == null || value.isEmpty){
              collegeState.updateErrorMessage(update:'please this field is required');
            }else if(value.length < 10){
               collegeState.updateErrorMessage(update:'please this field must not be shorter than 10 characters');
            }
            else{
               collegeState.updateErrorMessage(update:null);
               collegeState.updateSpeciality(update:value);
            }
          },
        ),
      ),
    );
  }
}
