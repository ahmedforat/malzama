import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';
import '../../state_provider/school_student_state_provider.dart';

class SelectBaghdadSubRegion extends StatelessWidget {
  final Map<String, String> baghdadSubRegions = {
    'rusafa1': 'الرصافة الاولى',
    'rusafa2': 'الرصافة الثانية',
    'rusafa3': 'الرصافة الثالثة',
    'karkh1': 'الكرخ الاولى',
    'karkh2': 'الكرخ الثانية',
    'karkh3': 'الكرخ الثالثة',
  };

  @override
  Widget build(BuildContext context) {
    SchoolStudentPostSignUpState state =
        Provider.of<SchoolStudentPostSignUpState>(context,listen: false);
    print('city rebuilding');
    ScreenUtil.init(context);

    return Selector<SchoolStudentPostSignUpState,String>(
          selector: (context,stateObject) => stateObject.baghdadSubRegion,
          builder: (context,stateProvider,child) => Container(
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        padding: EdgeInsets.all(ScreenUtil().setSp(25)),
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
                            hint: new Text("Select your sub region"),
                            value: state.baghdadSubRegion,
                            onChanged: (String newValue){
                             if(state.schoolSection != null) {
                               state.updateSchoolList(name: newValue);
                             }
                             state.updateBaghdadSubRegion(update: newValue);
                            },
                            items: baghdadSubRegions.keys.map((subRegion) {
                              return DropdownMenuItem<String>(
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(500),
                                    height: ScreenUtil().setWidth(70),
                                    child: Text(
                                      "${baghdadSubRegions[subRegion]}",
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  value: subRegion);
                            }).toList()))))
          ],
        ),
      ),
    );
  }
}
