import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../state_providers/college_uploads_state_provider.dart';

class KeepTheSameUploadedPdfFileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    CollegeUploadingState uploadingState = Provider.of<CollegeUploadingState>(context, listen: false);
    return Container(
      child: Selector<CollegeUploadingState, bool>(
        selector: (context, stateProvider) => stateProvider.keepTheSameUploadedLecture,
        builder: (context, keep, _) => CheckboxListTile(
          title: Text('Keep the same uploaded lecture file'),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: uploadingState.setKeepTheSameUploadedLectureTo,
          value: keep,
        ),
      ),
    );
  }
}
