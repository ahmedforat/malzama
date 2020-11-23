// import 'package:flutter/material.dart';
// import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
// import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
// import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
// import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
// import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
// import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/material_state_provider..dart';
// import 'package:provider/provider.dart';
//
// // this is a custom selector widget for widgets and pages that depend on the MaterialStateProvider
//
// class CustomSelectorWidget<D> extends StatelessWidget {
//   final D Function(BuildContext, dynamic) selector;
//   final Widget Function(BuildContext, dynamic, Widget) builder;
//   final isAcademic;
//   CustomSelectorWidget(
//       {@required this.selector,
//       @required this.builder,
//       @required this.isAcademic});
//
//   @override
//   Widget build(BuildContext context) {
//     if (isAcademic) {
//       return Selector<
//           MaterialStateProvider<CollegeUploadedPDF, CollegeUploadedVideo>, D>(
//         selector: (context, stateProvider) {
//           return selector(context, stateProvider);
//         },
//         builder: (context,D data,Widget child) {
//           return builder(context,data,child);
//         },
//       );
//     } else {
//       return Selector<
//           MaterialStateProvider<SchoolUploadedPDF, SchoolUploadedVideo>, D>(
//         selector: (context, stateProvider) {
//           return selector(context, stateProvider);
//         },
//         builder: (context,D data,Widget child) {
//           return builder(context,data,child);
//         },
//       );
//     }
//   }
// }
//
//
// class CustomHomePageSelectorWidget<D> extends StatelessWidget {
//   final D Function(BuildContext, dynamic) selector;
//   final Widget Function(BuildContext, D, Widget) builder;
//   final isAcademic;
//   CustomHomePageSelectorWidget(
//       {@required this.selector,
//         @required this.builder,
//         @required this.isAcademic});
//
//   @override
//   Widget build(BuildContext context) {
//     if (isAcademic) {
//       return Selector<
//           DisplayHomePageStateProvider<CollegeUploadedPDF>, D>(
//         selector: (context, stateProvider) {
//           return selector(context, stateProvider);
//         },
//         builder: (context,D data,Widget child) {
//           return builder(context,data,child);
//         },
//       );
//     } else {
//       return Selector<
//           DisplayHomePageStateProvider<SchoolUploadedPDF>, D>(
//         selector: (context, stateProvider) {
//           return selector(context, stateProvider);
//         },
//         builder: (context,D data,Widget child) {
//           return builder(context,data,child);
//         },
//       );
//     }
//   }
// }
//
//
//
//
