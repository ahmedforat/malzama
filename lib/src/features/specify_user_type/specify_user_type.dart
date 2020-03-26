


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../signup/pages/college_post_signup.dart';
import '../signup/state_provider/college_post_signup_state.dart';
import '../signup/state_provider/common_widgets_state_provider.dart';
import '../signup/state_provider/school_student_state_provider.dart';
import '../signup/widgets/abroad/abroad_college_student_post_signup.dart';


class SpecifyUserTypeWidget extends StatelessWidget {

  void _navigateTo({BuildContext context,String page}){
    Navigator.of(context).pushNamed(page);
  }

  @override
  Widget build(BuildContext context) {

    SchoolStudentPostSignupState schoolsState  = Provider.of<SchoolStudentPostSignupState>(context,listen: false);
    CollegePostSignUpState collegeState = Provider.of<CollegePostSignUpState>(context,listen: false);

    ScreenUtil.init(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff696b9e),
          title: Text('choose account type'),
        ),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setSp(180)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('استاذ جامعي'),
                onTap: ()async{
                  CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context,listen: false);
                 
                  commonState.setAccountTypeTo(AccountType.COLLEGE_LECTURER);
                  Widget target;
                  if(commonState.province == 'abroad'){
                    await commonState.loadAllCountries();
                      target = AbroadCollegePostSignup();
                  }else{
                      await collegeState.loadAllUniversitiesAndColleges();
                      target = CollegeStudentPostSignUpWidget();
                  }
                  
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => target
                  ));

                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('طالب جامعي'),
                onTap: ()async{
                  CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context,listen: false);
                  commonState.setAccountTypeTo(AccountType.COLLEGE_STUDENT);
                  Widget target;
                  if(commonState.province == 'abroad'){
                    await commonState.loadAllCountries();
                    target = AbroadCollegePostSignup();
                  }else{
                        await collegeState.loadAllUniversitiesAndColleges();
                        target = CollegeStudentPostSignUpWidget();
                  }
                
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => target
                  ));
                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('استاذ اعدادية'),
                onTap: ()async{
                   CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context,listen: false);
                   commonState.setAccountTypeTo(AccountType.SCHOOL_TEACHER);
                   

                },
              ),

              ListTile(
                leading: FaIcon(FontAwesomeIcons.user,color: Colors.black,),
                title: Text('طالب اعدادي'),
                onTap: (){
                  CommonWidgetsStateProvider commonState = Provider.of<CommonWidgetsStateProvider>(context,listen: false);
                  commonState.setAccountTypeTo(AccountType.SCHOOL_STUDENT);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
