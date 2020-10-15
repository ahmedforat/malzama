import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:provider/provider.dart';

import '../../features/home/presentation/widgets/bottom_nav_bar_pages/materialPage/material_state_provider..dart';
import '../platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import '../platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import '../platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import '../platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';

ChangeNotifierProvider<MaterialStateProvider<BaseUploadingModel, BaseUploadingModel>> generateMaterialStateProvider(
    {@required bool isAcademic}) {
  if (isAcademic) {
    return ChangeNotifierProvider<MaterialStateProvider<CollegeUploadedPDF, CollegeUploadedVideo>>(
      create: (context) => MaterialStateProvider<CollegeUploadedPDF, CollegeUploadedVideo>(),
      lazy: true,
    );
  } else {
    return ChangeNotifierProvider<MaterialStateProvider<SchoolUploadedPDF, SchoolUploadedVideo>>(
      create: (context) => MaterialStateProvider<SchoolUploadedPDF, SchoolUploadedVideo>(),
      lazy: true,
    );
  }
}
