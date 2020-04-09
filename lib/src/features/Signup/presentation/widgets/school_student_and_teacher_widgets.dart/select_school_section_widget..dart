import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';
import '../../state_provider/school_student_state_provider.dart';

class SelectSchoolSectionWidget extends StatelessWidget {

  final Map commonState;
  SelectSchoolSectionWidget({this.commonState});
  @override
  Widget build(BuildContext context) {
    
    SchoolStudentPostSignUpState state =
        Provider.of<SchoolStudentPostSignUpState>(context, listen: false);
    print('city rebuilding');
    ScreenUtil.init(context);

    return Selector<SchoolStudentPostSignUpState, String>(
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
                  _handleOnChanged(val, commonState, state);
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
                  _handleOnChanged(val, commonState, state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _handleOnChanged(String val, Map commonState,
    SchoolStudentPostSignUpState schoolState) {
  if (commonState['province'] != 'baghdad') {
    schoolState.updateSchoolList(
        name: commonState['province']);
  } else {
    if (schoolState.baghdadSubRegion != null)
      schoolState.updateSchoolList(
          name: schoolState.baghdadSubRegion);
  }
}
