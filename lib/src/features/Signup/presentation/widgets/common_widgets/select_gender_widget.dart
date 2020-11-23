import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_provider/common_widgets_state_provider.dart';

class SelectGenderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('gender rebuilding');
    ScreenUtil.init(context);
    CommonWidgetsStateProvider state = Provider.of<CommonWidgetsStateProvider>(context, listen: false);
    return Selector<CommonWidgetsStateProvider, List<String>>(
        selector: (context, stateProvider) => [
              stateProvider.gender,
              stateProvider.errorMessages[6],
            ],
        builder: (context, data, __) => Container(
              margin: EdgeInsets.only(top: ScreenUtil().setSp(50)),
              padding: EdgeInsets.all(ScreenUtil().setSp(30)),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(errorText: data[1]),
                        isDense: true,
                        hint: new Text("Select gender"),
                        value: state.gender,
                        onChanged: (String val) {
                          state.updateGender(newGender: val);
                        },
                        items: [
                          DropdownMenuItem<String>(
                            child: Text('Male'),
                            value: 'male',
                          ),
                          DropdownMenuItem<String>(
                            child: Text('Female'),
                            value: 'female',
                          ),
                        ]),
                  )))
                ],
              ),
            ));
  }
}
