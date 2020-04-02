import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/college_post_signup_state.dart';

class SelectCollegeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CollegePostSignUpState state = Provider.of<CollegePostSignUpState>(context,listen: false);
    print('select college rebuilding');
    ScreenUtil.init(context);

    return Selector<CollegePostSignUpState, List<dynamic>>(
      selector: (context, stateProvider) => [stateProvider.college,stateProvider.collegeList],
      builder: (context, selectedValue, _) => Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
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
                            hint: new Text("Select your college"),
                            value: state.college,
                            onChanged: state.university == null ? null: (String newValue) {
                              state.updateCollege(update: newValue);
                            },
                            items: state.collegeList== null ? null:state.collegeList.map((college) {
                              return DropdownMenuItem<String>(
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(600),
                                    height: ScreenUtil().setWidth(70),
                                    child: Text(
                                      college[0],
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  value: college[0]);
                            }).toList()))))
          ],
        ),
      ),
    );
  }
}
