import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/Navigator/routes_names.dart';
import '../../../../../core/general_widgets/comment_state_change_notifier.dart';
import '../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../models/materials/college_material.dart';
import '../../state_provider/user_info_provider.dart';
import '../my_materials/materialPage/upper_uploading_banner/college_uploading_pages/college_lecture_uploading_form.dart';
import '../my_materials/materialPage/upper_uploading_banner/college_uploading_pages/collge_video_uploading_form.dart';
import '../my_materials/materialPage/upper_uploading_banner/school_uploading_widgets/school_lecture_uploading_form.dart';
import '../my_materials/materialPage/upper_uploading_banner/school_uploading_widgets/school_video_uploading_form.dart';
import '../my_materials/materialPage/upper_uploading_banner/state_providers/college_uploads_state_provider.dart';
import '../my_materials/materialPage/upper_uploading_banner/state_providers/school_uploads_state_provider.dart';
import '../shared/materials_details_pages/details_pages/college_pdf_details_page.dart';
import '../shared/materials_details_pages/details_pages/school_pdf_details_page.dart';
import 'pages/pdfs_page.dart';
import 'state/pdf_state_provider.dart';

// handle the routing inside the nested navigator of the notifications page
Route<dynamic> homeOnGenerateRoutes(RouteSettings settings) {
  WidgetBuilder builder;
  final bool isAcademic = locator<UserInfoStateProvider>().isAcademic;

  switch (settings.name) {
    case '/':
      builder = (context) =>
          DisplayHomePage() ??
          Container(
            color: Colors.white,
            child: Center(
              child: Text('Home Page'),
            ),
          );
      break;

    // view lecture details page
    case RouteNames.VIEW_LECTURE_DETAILS:
      final int pos = settings.arguments;
      print('Hello Navigator of lectures');
      final Widget _child =
          isAcademic ? CollegePDFDetailsPage<PDFStateProvider>(pos: pos) : SchoolPDFDetailsPage<PDFStateProvider>(pos: pos);
      builder = (context) => CommentStateChangeNotifierProvider<PDFStateProvider>(
            child: _child,
            pos: pos,
          );
      break;

    case RouteNames.EDIT_COLLEGE_MATERIAL:
      final Map<String, dynamic> args = settings.arguments;
      final bool isVideo = args['isVideo'] as bool;
      final CollegeMaterial payload = args['payload'] as CollegeMaterial;

      builder = (context) => ChangeNotifierProvider<CollegeUploadingState>(
            create: (context) => CollegeUploadingState(forEdit: true, data: payload),
            builder: (context, _) => isVideo ? CollegeVideoUploadingFormWidget() : CollegeLectureUploadingFormWidget(),
          );
      break;

    case RouteNames.EDIT_SCHOLL_MATERIAL:
      final Map<String, dynamic> args = settings.arguments;
      final bool isVideo = args['isVideo'] as bool;
      final Map<String, dynamic> payload = args['payload'];

      builder = (context) => ChangeNotifierProvider<SchoolUploadState>(
            create: (context) => SchoolUploadState(),
            builder: (context, _) => isVideo ? SchoolVideoUploadingFormWidget() : SchoolLectureUploadingFormWidget(),
          );
      break;
  }

  return new MaterialPageRoute(builder: builder);
}
