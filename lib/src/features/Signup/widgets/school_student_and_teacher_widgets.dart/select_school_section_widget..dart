

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/signup/state_provider/common_widgets_state_provider.dart';
import 'package:malzama/src/features/signup/state_provider/school_student_state_provider.dart';
import 'package:provider/provider.dart';

class SelectSchoolSectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SchoolStudentPostSignupState state =
        Provider.of<SchoolStudentPostSignupState>(context, listen: false);

    CommonWidgetsStateProvider commonWidgetsStateProvider =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    print('city rebuilding');
    ScreenUtil.init(context);



    return Selector<SchoolStudentPostSignupState,String>(
      selector: (context,stateObject) => stateObject.schoolSection,

      builder:(context,_,__ ) => Container(
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
                  onChanged:  (val) async {
                          state.updateSchoolSection(update: val);
                         if(commonWidgetsStateProvider.province != 'baghdad'){
                           state.updateSchoolList(name:commonWidgetsStateProvider.province);
                         }else{
                           if(state.baghdadSubRegion != null)
                             state.updateSchoolList(name: state.baghdadSubRegion);
                         }
                        },

                ),
              ),
              Expanded(
                child: RadioListTile(
                  title: Text('تطبيقي'),
                  value: 'app',
                  groupValue: state.schoolSection,
                  onChanged:  (val) async {
                    state.updateSchoolSection(update: val);
                    if(commonWidgetsStateProvider.province != 'baghdad'){
                      state.updateSchoolList(name:commonWidgetsStateProvider.province);
                    }else{
                      if(state.baghdadSubRegion != null)
                        state.updateSchoolList(name: state.baghdadSubRegion);
                    }
                    state.setState();
                  },
                ),
              ),
            ],
          ),

      ),
    );
  }
}
