import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'package:malzama/src/features/signup/state_provider/school_student_state_provider.dart';
import 'package:provider/provider.dart';

class SelectSchoolWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SchoolStudentPostSignupState state =
        Provider.of<SchoolStudentPostSignupState>(context);
    print('city rebuilding');
    ScreenUtil.init(context);

    return Selector<SchoolStudentPostSignupState,String>(
      selector: (context,stateobject) =>stateobject.school,

      builder:(context,_,__)  => Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        padding: EdgeInsets.all(ScreenUtil().setSp(25)),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(15))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          isDense: true,
                            hint: new Text("Select your school"),
                            value: state.school,
                            onChanged:state.schoolList == null ?null:
                                 (String newValue) {
                                    state.updateSchool(update: newValue);
                                  },
                            items: state.schoolList == null ?null:state.schoolList.keys.map((school) {
                              return DropdownMenuItem<String>(
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(500),
                                    height: ScreenUtil().setWidth(70),
                                    child: Text(
                                      "$school",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  value: school);
                            }).toList()))))
          ],
        ),
      ),
    );
  }
}
