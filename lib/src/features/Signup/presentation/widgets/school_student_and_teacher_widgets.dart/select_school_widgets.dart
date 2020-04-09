import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/school_student_state_provider.dart';

class SelectSchoolWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SchoolStudentPostSignUpState state =
        Provider.of<SchoolStudentPostSignUpState>(context);
    print('city rebuilding');
    ScreenUtil.init(context);

    return Selector<SchoolStudentPostSignUpState, String>(
      selector: (context, stateobject) => stateobject.school,
      builder: (context, _, __) => Container(
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
                            onChanged: state.schoolList == null
                                ? null
                                : (String newValue) {
                                    state.updateSchool(update: newValue);
                                  },
                            items: state.schoolList == null
                                ? null
                                : state.sortedSchoolList.map((school) {
                                    return DropdownMenuItem<String>(
                                        child: SizedBox(
                                          width: ScreenUtil().setWidth(500),
                                          height: ScreenUtil().setWidth(70),
                                          child: Text(
                                            "$school",
                                            textAlign: TextAlign.right,
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
