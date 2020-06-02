import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:provider/provider.dart';

class QuizInitialAddButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Center(
      child: Container(
        width: ScreenUtil().setWidth(200),
       height: ScreenUtil().setHeight(200),
       decoration: BoxDecoration(
         shape: BoxShape.circle,
         //color: Colors.blueAccent,
         border: Border.all(color: Colors.blueAccent,width: 2.3),
       ),
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            size: 50,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
