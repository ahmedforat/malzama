// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../../../core/Navigator/routes_names.dart';
// import '../../../../../../../core/general_widgets/helper_functions.dart';
// import '../../../../../../../core/general_widgets/helper_utils/edit_or_delete_options_widget.dart';
// import '../../../../../../../core/references/references.dart';
// import '../../../../state_provider/user_info_provider.dart';
// import '../../../shared/material_holding_widgets/college/college_pdf_holding_widget.dart';
// import '../../../shared/material_holding_widgets/school/school_pdf_holding_widget.dart';
// import '../material_state_provider..dart';
//
// class ExploreMaterialPage extends StatefulWidget {
//   @override
//   _ExploreMaterialPageState createState() => _ExploreMaterialPageState();
// }
//
// class _ExploreMaterialPageState extends State<ExploreMaterialPage> with SingleTickerProviderStateMixin {
//   TabController _tabController;
//
//   @override
//   void initState() {
//     _tabController = new TabController(length: 3, vsync: this);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//     return SafeArea(
//       child: Scaffold(
//         //backgroundColor: Colors.grey[300],
//         body: Container(
//             padding: EdgeInsets.all(ScreenUtil().setSp(25)),
//             child: ListView(
//               children: <Widget>[
//                 Container(
//                   //color: Colors.white38,
//                   height: ScreenUtil().setHeight(300),
//                   child: MyUploadedMaterialsCountsWidget(),
//                 ),
//                 TabBar(controller: _tabController, tabs: [
//                   Tab(
//                     icon: FaIcon(
//                       FontAwesomeIcons.youtube,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                   Tab(
//                     icon: FaIcon(
//                       FontAwesomeIcons.filePdf,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                   Tab(
//                     icon: FaIcon(
//                       FontAwesomeIcons.list,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                 ]),
//                 SizedBox(
//                   height: ScreenUtil().setHeight(1300),
//                   child: Container(
//                     child: TabBarView(
//                       physics: NeverScrollableScrollPhysics(),
//                       controller: _tabController,
//                       children: [
//                         Container(
//                           child: VideoListView(),
//                         ),
//                         Container(
//                           child: PDFListView(),
//                         ),
//                         Container(
//                           color: Colors.black12,
//                           child: QuizListView(),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(
//             Icons.add,
//             size: ScreenUtil().setSp(80),
//           ),
//           onPressed: () async {
//             //await QuizAccessObject().deleteUploadedMaterial(MyUploaded.QUIZES);
//            // var res = await QuizAccessObject().getUploadedMaterials(MyUploaded.QUIZES);
//             //print(res[0]);
//             // print('deleted uploaded');
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class MyUploadedMaterialsCountsWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//     final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).userData.accountType;
//     ScreenUtil.init(context);
//     return Selector<UserInfoStateProvider, List<int>>(
//       selector: (context, stateProvider) => [
//         stateProvider.uploadedPDFsCount,
//         stateProvider.uploadedVideosCount,
//         stateProvider.uploadedQuizsCount,
//       ],
//       builder: (context, uploads, _) => Container(
//         padding: EdgeInsets.all(ScreenUtil().setSp(30)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               References.isTeacher(accountType) ? 'My uploaded materials' : 'My saved materials',
//               style: TextStyle(fontSize: ScreenUtil().setSp(80), fontWeight: FontWeight.bold),
//             ),
//             SizedBox(
//               height: ScreenUtil().setHeight(20),
//             ),
//             Row(
//               children: <Widget>[
//                 Text(
//                   '${uploads[1]} videos',
//                   style: TextStyle(
//                     fontSize: ScreenUtil().setSp(40),
//                   ),
//                 ),
//                 SizedBox(
//                   width: ScreenUtil().setWidth(30),
//                 ),
//                 Text(
//                   '${uploads[0]} lectures',
//                   style: TextStyle(
//                     fontSize: ScreenUtil().setSp(40),
//                   ),
//                 ),
//                 SizedBox(
//                   width: ScreenUtil().setWidth(30),
//                 ),
//                 Text(
//                   '${uploads[2]} quizes',
//                   style: TextStyle(
//                     fontSize: ScreenUtil().setSp(40),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PDFListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).userData.accountType;
//     final bool isAcademic = HelperFucntions.isAcademic(accountType);
//     return Selector<MaterialStateProvider, List<dynamic>>(
//       selector: (context, stateProvider) => [
//         stateProvider.isFetchingPDFs,
//         stateProvider.myPDFs.length,
//       ],
//       builder: (context, state, _) => Material(
//         color: Colors.grey[300],
//         child: state[0]
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : state[1] == 0
//                 ? Center(
//                     child: Text(
//                       'There are no lectures uploaded yet',
//                       style: TextStyle(
//                         fontSize: ScreenUtil().setSp(50),
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: state[1],
//                     itemBuilder: (context, pos) => isAcademic
//                         ? CollegePDFHoldingWidget(
//                             pos: pos,
//                           )
//                         : SchoolPDFHoldingWidget(
//                             pos: pos,
//                           ),
//                   ),
//       ),
//     );
//   }
// }
//
// class VideoListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final String accountType = Provider.of<UserInfoStateProvider>(context, listen: false).userData.accountType;
//     final bool isAcademic = HelperFucntions.isAcademic(accountType);
//     return Selector<MaterialStateProvider, List<dynamic>>(
//       selector: (context, stateProvider) => [
//         stateProvider.isFetchingVideos,
//         stateProvider.myVideos.length,
//       ],
//       builder: (context, state, _) => Material(
//         child: state[0]
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : state[1] == 0
//                 ? Center(
//                     child: Text(
//                       'There are no videos uploaded yet',
//                       style: TextStyle(
//                         fontSize: ScreenUtil().setSp(50),
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: state[1],
//                     itemBuilder: (context, pos) => isAcademic ? CollegePDFHoldingWidget(pos: pos) : SchoolPDFHoldingWidget(pos: pos),
//                   ),
//       ),
//     );
//   }
// }
//
// class QuizListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     MaterialStateProvider materialStateProvider = Provider.of<MaterialStateProvider>(context, listen: false);
//     return Selector<MaterialStateProvider, List<dynamic>>(
//       selector: (context, stateProvider) => [
//         stateProvider.isFetchingQuizes,
//         stateProvider.myQuizes.length,
//       ],
//       builder: (context, state, _) => Container(
//         child: state[0]
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : state[1] == 0
//                 ? Center(
//                     child: Text(
//                       'There are no quizes uploaded yet',
//                       style: TextStyle(
//                         fontSize: ScreenUtil().setSp(50),
//                       ),
//                     ),
//                   )
//                 : ListView.builder(
//                     shrinkWrap: false,
//                     itemCount: state[1],
//                     itemBuilder: (context, pos) => InkWell(
//                       onTap: () {
//                         Navigator.of(context).pushNamed(
//                           RouteNames.TAKE_QUIZ_EXAM,
//                           arguments: {'data': materialStateProvider.myQuizes[pos], 'fromLocal': true},
//                         );
//                       },
//                       child: MyUploadedQuizWidget(pos: pos),
//                     ),
//                   ),
//       ),
//     );
//   }
// }
//
// class MyUploadedQuizWidget extends StatelessWidget {
//   final int pos;
//
//   MyUploadedQuizWidget({
//     @required this.pos,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//     UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
//     MaterialStateProvider materialStateProvider = Provider.of<MaterialStateProvider>(context, listen: false);
//     print('=================================');
//     print(materialStateProvider.myQuizes[0].toJSON());
//     print('================================');
//     return Card(
//       margin: EdgeInsets.only(bottom: ScreenUtil().setSp(50)),
//       child: Container(
//         padding: EdgeInsets.all(ScreenUtil().setSp(20)),
//         height: ScreenUtil().setHeight(700),
//         width: ScreenUtil().setWidth(500),
//         child: Row(
//           children: [
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Container(
//                         width: double.infinity,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 top: ScreenUtil().setSp(30),
//                                 left: ScreenUtil().setSp(30),
//                               ),
//                               child: Text(
//                                 materialStateProvider.myQuizes[pos].credentials.title ?? 'dd',
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 top: ScreenUtil().setSp(10),
//                                 left: ScreenUtil().setSp(30),
//                               ),
//                               child: Text(
//                                 '(' + materialStateProvider.myQuizes[pos].questionsCount.toString() + ' questions)',
//                                 style: TextStyle(fontSize: ScreenUtil().setSp(35)),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.only(
//                                 top: ScreenUtil().setSp(40),
//                                 left: ScreenUtil().setSp(30),
//                               ),
//                               child: Text(
//                                 materialStateProvider.myQuizes[pos].credentials.description ?? 'dd',
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(fontSize: ScreenUtil().setSp(35)),
//                               ),
//                             ),
//                           ],
//                           mainAxisSize: MainAxisSize.min,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: ScreenUtil().setSp(50),
//                               left: ScreenUtil().setSp(30),
//                             ),
//                             child: Text(
//                               materialStateProvider.myQuizes[pos].author.firstName +
//                                   ' ' +
//                                   materialStateProvider.myQuizes[pos].author.lastName,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: ScreenUtil().setSp(30)),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: ScreenUtil().setSp(5),
//                               left: ScreenUtil().setSp(30),
//                             ),
//                             child: Text(
//                               materialStateProvider.myQuizes[pos].credentials.college +
//                                   ' ' +
//                                   materialStateProvider.myQuizes[pos].credentials.university,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: ScreenUtil().setSp(30)),
//                             ),
//                           ),
//                           SizedBox(
//                             height: ScreenUtil().setHeight(25),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.all(ScreenUtil().setSp(20)),
//               width: ScreenUtil().setWidth(250),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                           icon: Icon(Icons.edit),
//                           // onPressed: () {
//                           //   userInfoStateProvider.setBottomNavBarVisibilityTo(false);
//                           //   showModalBottomSheet(
//                           //     backgroundColor: Colors.transparent,
//                           //     shape: RoundedRectangleBorder(),
//                           //     context: context,
//                           //     builder: (context) => EditOrDeleteOptionWidget(
//                           //       onEdit: () async {
//                           //         Navigator.of(context).pop();
//                           //         await Future.delayed(Duration(milliseconds: 200));
//                           //         Navigator.of(context).pushNamed(
//                           //           RouteNames.EDIT_UPLOADED_QUIZ,
//                           //           arguments: materialStateProvider.myQuizes[pos],
//                           //         );
//                           //       },
//                           //       onDelete: () async {
//                           //         // materialStateProvider.
//                           //         // final d = await QuizAccessObject().deleteUploadedMaterial(name:MyUploadedMaterialStores
//                           //         //      .MY_UPLOADED_QUIZES,id: 'dsad');
//                           //         //  print(d);
//                           //       },
//                           //     ),
//                           //   ).whenComplete(() async {
//                           //     await Future.delayed(Duration(milliseconds: 200));
//                           //     userInfoStateProvider.setBottomNavBarVisibilityTo(true);
//                           //   });
//                           // }),
//                       Padding(
//                         padding: EdgeInsets.only(
//                           top: ScreenUtil().setSp(15),
//                         ),
//                         child: Text(materialStateProvider.myQuizes[pos].postDate.substring(0, 10).toString()),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text('Stage ' + materialStateProvider.myQuizes[pos].credentials.stage),
//                       if (materialStateProvider.myQuizes[pos].credentials.semester != 'unknown')
//                         SizedBox(
//                           height: ScreenUtil().setHeight(20),
//                         ),
//                       if (materialStateProvider.myQuizes[pos].credentials.semester != 'unknown')
//                         Text('Semester ' + materialStateProvider.myQuizes[pos].credentials.semester)
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
