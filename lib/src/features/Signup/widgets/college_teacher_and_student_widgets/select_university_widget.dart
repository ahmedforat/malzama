import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/state_provider/college_post_signup_state.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'package:provider/provider.dart';

class SelectUniversityWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CollegePostSignUpState state = Provider.of<CollegePostSignUpState>(context,listen: false);
    print(' select university rebuilding');
    ScreenUtil.init(context);

    return Selector<CollegePostSignUpState, String>(
      selector: (context, stateProvider) => stateProvider.university,
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
                            hint: new Text("Select your university"),
                            value: state.university,
                            onChanged: (String newValue) {
                              state.updateUniversity(update: newValue);
                            },
                            items: state.universitiesList.map((university) {
                              return DropdownMenuItem<String>(
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(600),
                                    height: ScreenUtil().setWidth(70),
                                    child: Text(
                                      university,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  value: university);
                            }).toList()))))
          ],
        ),
      ),
    );
  }
}
