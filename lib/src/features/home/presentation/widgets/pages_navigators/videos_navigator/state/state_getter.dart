import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/videos_navigator/state/state_provider.dart';

import 'package:provider/provider.dart';

ChangeNotifierProvider<DisplayVideosPageState<BaseUploadingModel>> getDisplayVideosStateProvider({
  @required bool isAcademic,
  @required Widget child,
}) {
  return isAcademic
      ? ChangeNotifierProvider<DisplayVideosPageState<CollegeUploadedVideo>>(
          create: (context) => DisplayVideosPageState<CollegeUploadedVideo>(),
          child:  child,
        )
      : ChangeNotifierProvider< DisplayVideosPageState<SchoolUploadedVideo>>(
          create: (context) => DisplayVideosPageState<SchoolUploadedVideo>(),
          child:  child,
        );
}

DisplayVideosPageState<BaseUploadingModel> getVideosPageStateProvider({BuildContext context, bool listen}) {
  final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
  if (HelperFucntions.isAcademic(accountType)) {
    return Provider.of<DisplayVideosPageState<CollegeUploadedVideo>>(context, listen: listen);
  }
  return Provider.of<DisplayVideosPageState<SchoolUploadedVideo>>(context, listen: listen);
}
