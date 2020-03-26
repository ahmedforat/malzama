import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../state_provider/abroad_college_state.dart';

class SpecifyAbroadUniversityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setSp(200), right: ScreenUtil().setSp(200)),
      child: Selector<AbroadCollegeState, List<String>>(
        selector: (context, stateObject) =>
            [stateObject.universityErrorMessage, stateObject.university],
        builder: (context, state, __) => TextFormField(
          decoration: InputDecoration(
            errorText: state[0],
            labelText: 'Your University',
          ),
          onFieldSubmitted: (String value) {
            AbroadCollegeState abroadCollegeState =
                Provider.of<AbroadCollegeState>(context, listen: false);
            if (value == null || value.isEmpty) {
              abroadCollegeState.updateUniversityErrorMessage(
                  update: 'this field is required');
            } else if (value.length < 10) {
              abroadCollegeState.updateUniversityErrorMessage(
                  update: 'this field must not be shorter than 10 characters');
            } else {
              abroadCollegeState.updateUniversityErrorMessage(update: null);
              abroadCollegeState.updateUniversity(update: value);
            }
          },
        ),
      ),
    );
  }
}
