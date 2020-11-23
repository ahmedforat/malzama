import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../state_provider/quiz_uploading_state_provider.dart';


class QuizTitleWidget extends StatelessWidget {
  final TextEditingController controller;
  QuizTitleWidget({this.controller});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    QuizUploadingState quizUploadingState =
        Provider.of<QuizUploadingState>(context, listen: false);
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: 'title',
            border:OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))
                  ),),
        validator: (val) {
          if (val.isEmpty) {
            return 'this field is required';
          }
          return null;
        },
        onSaved: quizUploadingState.updateTitle,
      ),
    );
  }
}
