import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/state_provider/college_post_signup_state.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';

class SelectStageWidget extends StatelessWidget {
  final Map<int, String> stages = {
    1: 'المرحلة الاولى',
    2: 'المرحلة الثانية',
    3: 'المرحلة الثالثة',
    4: 'المرحلة الرابعة',
    5: 'المرحلة الخامسة',
    6: 'المرحلة السادسة',
  };

  @override
  Widget build(BuildContext context) {
    print('gender rebuilding');
    ScreenUtil.init(context);
    CollegePostSignUpState state =
        Provider.of<CollegePostSignUpState>(context, listen: false);

    return Selector<CollegePostSignUpState, List>(
        selector: (context, stateProvider) =>
            [stateProvider.college, stateProvider.stage],
        builder: (context, data, __) => Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
            padding: EdgeInsets.all(ScreenUtil().setSp(20)),
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
                                  hint: new Text("Select stage"),
                                  value:
                                      state.stage == null ? null : state.stage,
                                  onChanged: state.college == null
                                      ? null
                                      : (String val) {
                                          print(
                                              'this is the val $val and this is the runtimeType ${val.runtimeType}');
                                          state.updateStage(update: val);
                                        },
                                  items: state.college == null
                                      ? null
                                      : [
                                          for (var i = 1;
                                              i <= state.collegeStages;
                                              i++)
                                            getItem(i)
                                        ]))))
                ])));
  }

  Widget getItem(int key) {
    print(key);
    return DropdownMenuItem<String>(
      child: SizedBox(
        width: ScreenUtil().setWidth(580),
        height: ScreenUtil().setHeight(50),
        child: Text(
          stages[key],
          textAlign: TextAlign.right,
        ),
      ),
      value: stages[key],
    );
  }
}
