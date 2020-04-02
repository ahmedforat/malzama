import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';
import '../../state_provider/school_student_state_provider.dart';

class SelectSchoolSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SchoolStudentPostSignupState state =
        Provider.of<SchoolStudentPostSignupState>(context, listen: false);

    CommonWidgetsStateProvider commonWidgetsStateProvider =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    print('city rebuilding');
    ScreenUtil.init(context);

    return Selector<SchoolStudentPostSignupState, String>(
      selector: (context, stateObject) => stateObject.schoolSection,
      builder: (context, _, __) => Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        padding: EdgeInsets.all(ScreenUtil().setSp(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: RadioListTile(
                title: Text('احيائي'),
                value: 'bio',
                groupValue: state.schoolSection,
                onChanged: (val) async {
                  state.updateSchoolSection(update: val);
                  _handleOnChanged(val, commonWidgetsStateProvider, state);
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text('تطبيقي'),
                value: 'app',
                groupValue: state.schoolSection,
                onChanged: (val) async {
                  state.updateSchoolSection(update: val);
                  _handleOnChanged(val, commonWidgetsStateProvider, state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _handleOnChanged(String val, CommonWidgetsStateProvider commonState,
    SchoolStudentPostSignupState schoolState) {
  if (commonState.province != 'baghdad') {
    schoolState.updateSchoolList(
        name: commonState.province, commonState: commonState);
  } else {
    if (schoolState.baghdadSubRegion != null)
      schoolState.updateSchoolList(
          name: schoolState.baghdadSubRegion, commonState: commonState);
  }
}
