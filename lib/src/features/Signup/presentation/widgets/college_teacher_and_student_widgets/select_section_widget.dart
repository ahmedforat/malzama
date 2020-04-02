import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/college_post_signup_state.dart';

class SelectSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollegePostSignUpState state =
        Provider.of<CollegePostSignUpState>(context, listen: false);
    RegExp guessSection = new RegExp(r'طب|صيدلة|مرضية');
    print('university rebuilding');
    bool hasSections = false;

    if (state.college != null) {
      hasSections = !guessSection.hasMatch(state.college);
    }

    ScreenUtil.init(context);

    return Selector<CollegePostSignUpState, List<dynamic>>(
      selector: (context, stateProvider) =>
          [stateProvider.section, stateProvider.college],
      builder: (context, selectedValue, _) => Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
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
                      disabledHint: SizedBox(
                        width: ScreenUtil().setWidth(600),
                        height: ScreenUtil().setHeight(70),
                        child: Text(
                          state.college == null
                              ? "Select your section"
                              : state.section,
                          textAlign: state.college == null ?TextAlign.left:TextAlign.right,
                        ),
                      ),
                      hint: new Text("Select your section"),
                      value: state.section,
                      onChanged: !hasSections
                          ? null
                          : (String newValue) {
                              state.updateSection(update: newValue);
                            },
                      items: !hasSections
                          ? null
                          : state.sections.map(
                              (section) {
                                return DropdownMenuItem<String>(
                                    child: SizedBox(
                                      width: ScreenUtil().setWidth(100),
                                      height: ScreenUtil().setWidth(70),
                                      child: Text(
                                        section,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    value: section);
                              },
                            ).toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
