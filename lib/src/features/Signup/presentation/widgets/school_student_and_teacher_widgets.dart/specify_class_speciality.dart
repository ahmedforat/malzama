import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:provider/provider.dart';

import '../../state_provider/school_student_state_provider.dart';

class SelectClassSpeciality extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print('gender rebuilding');
    ScreenUtil.init(context);
    SchoolStudentPostSignupState state = 
        Provider.of<SchoolStudentPostSignupState>(context, listen: false);
    return Selector<SchoolStudentPostSignupState, String>(
        selector: (context, stateProvider) => stateProvider.speciality,
        builder: (context, _, __) => Container(
              margin: EdgeInsets.only(top: ScreenUtil().setSp(50)),
              padding: EdgeInsets.all(ScreenUtil().setSp(30)),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                        isDense: true,
                        hint: new Text("Select your class speciality"),
                        value: state.speciality,
                        onChanged: (String val) {
                          state.updateSpeciality(update: val);
                        },
                        items: References.classes.keys.map((key) {
                          return DropdownMenuItem<String>(
                              child: SizedBox(
                                width: ScreenUtil().setWidth(500),
                                height: ScreenUtil().setWidth(70),
                                child: Text(References.classes[key],
                                    textAlign: TextAlign.right,
                                    style: TextStyle(color: Colors.black),),
                                  
                              ),
                              value: key);
                        }).toList()),
                  )))
                ],
              ),
            ));
  }
}
