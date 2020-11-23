import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../state_provider/quiz_uploading_state_provider.dart';

class QuizDescriptionWidget extends StatelessWidget {
  final TextEditingController controller;

  QuizDescriptionWidget({this.controller});
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: 250),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(
        controller:controller,
        maxLines: null,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border:OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))
                  ),
          labelText: 'brief description',
        ),
        validator: (val){
          if(val.isEmpty){
            return 'this field is required';
          }
          return null;
        },
        onSaved: Provider.of<QuizUploadingState>(context, listen: false)
            .updateDescription,
      ),
    );
  }
}
