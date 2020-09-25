import 'package:flutter/material.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/videos_navigator/state/state_provider.dart';

import 'package:provider/provider.dart';

class DisplayVideosCustomSelector<D> extends StatelessWidget {
  final D Function(BuildContext, dynamic) selector;
  final Widget Function(BuildContext, dynamic, Widget) builder;
  final isAcademic;

  DisplayVideosCustomSelector({
    @required this.selector,
    @required this.builder,
    @required this.isAcademic,
  });

  @override
  Widget build(BuildContext context) {

    return isAcademic
        ? Selector<DisplayVideosPageState<CollegeUploadedVideo>, D>(
            selector: selector,
            builder: builder,
          )
        : Selector<DisplayVideosPageState<SchoolUploadedVideo>, D>(
            selector: selector,
            builder: builder,
          );
  }
}
