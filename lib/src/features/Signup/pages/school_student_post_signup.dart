
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../state_provider/common_widgets_state_provider.dart';
import '../widgets/school_student_and_teacher_widgets.dart/select_baghdad_sub_region.dart';
import '../widgets/school_student_and_teacher_widgets.dart/select_school_section_widget..dart';
import '../widgets/school_student_and_teacher_widgets.dart/select_school_widgets.dart';

class SchoolStudentPostSignUpWidget extends StatefulWidget {
  @override
  _SchoolStudentPostSignUpWidgetState createState() => _SchoolStudentPostSignUpWidgetState();
}

class _SchoolStudentPostSignUpWidgetState extends State<SchoolStudentPostSignUpWidget> {

  @override
  Widget build(BuildContext context) {

    CommonWidgetsStateProvider stateProvider = Provider.of<CommonWidgetsStateProvider>(context,listen: false);
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff696b9e),
        title: Text('Complete Signup'),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(150)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height:ScreenUtil().setHeight(170)),
            if(stateProvider.province == 'baghdad')
              SelectBaghdadSubRegion(),
            SelectSchoolSectionWidget(),
            SelectSchoolWidget(),
            SizedBox(height: ScreenUtil().setHeight(100),),
            RaisedButton(
                color: Color(0xff696b9e),
                onPressed: ()async{
                  print(await rootBundle.loadString('assets/iraq_schools_folder/all_schools.json'));
                },
                child:Text('Done',style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}