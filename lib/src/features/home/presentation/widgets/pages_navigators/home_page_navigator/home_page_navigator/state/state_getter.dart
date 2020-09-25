import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:malzama/src/features/home/presentation/widgets/pages_navigators/home_page_navigator/home_page_navigator/state/state_provider.dart';
import 'package:provider/provider.dart';

ChangeNotifierProvider<DisplayHomePageStateProvider<BaseUploadingModel>> getDisplayHomePageStateProvider({
  @required bool isAcademic,
}) {
  if (isAcademic) {
    return ChangeNotifierProvider<DisplayHomePageStateProvider<CollegeUploadedPDF>>(
      create: (context) => DisplayHomePageStateProvider<CollegeUploadedPDF>(),
      lazy: true,
    );
  }
  return ChangeNotifierProvider<DisplayHomePageStateProvider<SchoolUploadedPDF>>(
    create: (context) => DisplayHomePageStateProvider<SchoolUploadedPDF>(),
    lazy: true,
  );
}

DisplayHomePageStateProvider<BaseUploadingModel> getHomePageStateProvider({BuildContext context, bool listen}) {
  final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).account_type;
  if (HelperFucntions.isAcademic(accountType)) {
    return Provider.of<DisplayHomePageStateProvider<CollegeUploadedPDF>>(context, listen: listen);
  }
  return Provider.of<DisplayHomePageStateProvider<SchoolUploadedPDF>>(context, listen: listen);
}
