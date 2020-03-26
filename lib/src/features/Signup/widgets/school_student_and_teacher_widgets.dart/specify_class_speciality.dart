import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';

class SelectClassSpeciality extends StatelessWidget {
  Map<String, String> classes = {
    'islamic': 'الاسلامية',
    'arabic': 'اللغة العربية',
    'english': 'اللغة الانكليزية',
    'french': 'اللغة الفرنسية',
    'bio': 'الاحياء',
    'math': 'الرياضيات',
    'chemistry': 'الكيمياء',
    'physics': 'الفيزياء'
  };
  @override
  Widget build(BuildContext context) {
    print('gender rebuilding');
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    return Selector<CommonWidgetsStateProvider, String>(
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
                        items: classes.keys.map((key) {
                          return DropdownMenuItem<String>(
                              child: SizedBox(
                                width: ScreenUtil().setWidth(185),
                                height: ScreenUtil().setWidth(70),
                                child: Text(classes[key],
                                    textAlign: TextAlign.center),
                              ),
                              value: key);
                        }).toList()),
                  )))
                ],
              ),
            ));
  }
}
