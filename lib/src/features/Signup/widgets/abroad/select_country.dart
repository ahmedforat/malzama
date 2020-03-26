import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/abroad_college_state.dart';
import '../../state_provider/common_widgets_state_provider.dart';

class SelectCountryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CommonWidgetsStateProvider commonState =
        Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    AbroadCollegeState abroadState =
        Provider.of<AbroadCollegeState>(context, listen: false);

    print('select college rebuilding');
    ScreenUtil.init(context);

    return Selector<AbroadCollegeState, String>(
      selector: (context, stateProvider) => stateProvider.currentCountry,
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
                            hint: new Text("Select your current country"),
                            value: abroadState.currentCountry,
                            onChanged: (String newValue) {
                              abroadState.updateCurrentCountry(
                                  update: newValue);
                            },
                            items: commonState.allCountries.map((country) {
                              return DropdownMenuItem<String>(
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(600),
                                    height: ScreenUtil().setWidth(90),
                                    child: Text(
                                      country,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  value: country);
                            }).toList()))))
          ],
        ),
      ),
    );
  }
}
