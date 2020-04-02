import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/college_post_signup_state.dart';

class CollegeLecturerSpecialityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollegePostSignUpState collegeState = Provider.of<CollegePostSignUpState>(context,listen:false);
    ScreenUtil.init(context);


    print("sepciality controller is ${collegeState.speciality}");


    return  Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
        padding: EdgeInsets.all(ScreenUtil().setSp(20)),

        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'your speciality',
          ),
          validator: (String value){
            if(value == null || value.isEmpty){
              return 'please this field is required';
            }else if(value.length < 10){
               return 'please this field must not be shorter than 10 characters';
            }
            else{
               collegeState.updateSpeciality(update:value);
               return null;
            }
          },
        ),
      
    );
  }
}
