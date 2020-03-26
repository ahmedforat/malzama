import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/state_provider/college_post_signup_state.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'package:malzama/src/features/signup/widgets/college_teacher_and_student_widgets/college_lecturer_speciality.dart';
import 'package:malzama/src/features/signup/widgets/college_teacher_and_student_widgets/select_college_widget.dart';
import 'package:malzama/src/features/signup/widgets/college_teacher_and_student_widgets/select_section_widget.dart';
import 'package:malzama/src/features/signup/widgets/college_teacher_and_student_widgets/select_stage_widget.dart';
import 'package:malzama/src/features/signup/widgets/college_teacher_and_student_widgets/select_university_widget.dart';
import 'package:provider/provider.dart';

class CollegeStudentPostSignUpWidget extends StatefulWidget {
  @override
  _CollegeStudentPostSignUpWidgetState createState() =>
      _CollegeStudentPostSignUpWidgetState();
}

class _CollegeStudentPostSignUpWidgetState
    extends State<CollegeStudentPostSignUpWidget> {
  GlobalKey tooltipKey = new GlobalKey();


  @override
  Widget build(BuildContext context) {
    CommonWidgetsStateProvider commonState =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
        CollegePostSignUpState collegeState = Provider.of<CollegePostSignUpState>(context,listen: false);



    print('rebuilding final page');
    ScreenUtil.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xff696b9e),
        title: Text('Complete Signup'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(150)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(170)),
            SelectUniversityWidget(),
            SelectCollegeWidget(),
            if (commonState.accountType == AccountType.COLLEGE_STUDENT)
              SelectSectionWidget(),
            if (commonState.accountType == AccountType.COLLEGE_STUDENT)
              SelectStageWidget(),
            if (commonState.accountType == AccountType.COLLEGE_LECTURER)
              CollegeLecturerSpecialityWidget(),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            Selector<CollegePostSignUpState, String>(
              selector: (context, stateObject) => stateObject.stage,
              builder: (context, stage, __) => RaisedButton(
                  color: Color(0xff696b9e),
                  onPressed: (){
                    if(commonState.accountType == AccountType.COLLEGE_LECTURER){
                      if(collegeState.university != null && collegeState.college != null && collegeState.speciality != null){
                      print( collegeState.fetchLecturerData(commonState));
                      }
                    }else{
                      if(collegeState.stage != null){
                        print( collegeState.fetchStudentData(commonState));
                      }
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

  
}
