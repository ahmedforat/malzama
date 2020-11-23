import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../state_provider/quiz_uploading_state_provider.dart';
import '../../upper_uploading_banner/state_providers/college_uploads_state_provider.dart';

class QuizSemesterWidget<T extends AbstractStateProvider> extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    T uploadingState = Provider.of<T>(context,listen:false);
    CollegeUploadingState state = Provider.of<CollegeUploadingState>(context,listen: false);
    print('=====================================================');
    print(state);
    print('=====================================================');
    print('building semester widget');
    print(uploadingState);
    print('building semester widget');
    return Selector<T,int>(
        selector: (context,stateProvider) => stateProvider.semester,
          builder:(context,_,__) => Padding(
        padding: EdgeInsets.only(right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(30),),
            Text('Semester',style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: ScreenUtil().setHeight(15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    //color: Colors.blueAccent,
                    alignment: Alignment.center,
                    width: 130,
                    height: 50,
                    child: RadioListTile(
                      value: 1,
                      groupValue: uploadingState.semester,
                      onChanged: uploadingState.updateSemester,
                      title: Text(
                        'First',
                        style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 50,
                    child: RadioListTile(
                      value: 2,
                      groupValue: uploadingState.semester,
                      onChanged: uploadingState.updateSemester,
                      title: Text(
                        'Second',
                        style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(30)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
