import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/Navigator/routes_names.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/pdf_state_provider.dart';
import 'file:///C:/Users/Karrar/Desktop/secret%20stuffs/current%20projects/online_learning/malzama/lib/src/features/home/presentation/pages/shared/college_material_details_pages/players/pdf_player/pdf_player_widget.dart';
import 'file:///C:/Users/Karrar/Desktop/secret%20stuffs/current%20projects/online_learning/malzama/lib/src/features/home/presentation/pages/shared/college_material_details_pages/players/video_player/video_player_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/school_material_details_widget/author_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/school_material_details_widget/school_materials_details_comment_section.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/school_material_details_widget/school_materials_details_last_update_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/school_material_details_widget/school_materials_details_published_in_widget.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';

import 'package:provider/provider.dart';

import '../college_material_details_widgets/author_widget.dart';
import '../college_material_details_widgets/college_material_last_update_widget.dart';
import '../college_material_details_widgets/college_material_published_in_widget.dart';
import '../college_material_details_widgets/comments_section_widget.dart';
import '../college_material_details_widgets/description_widget.dart';
import '../college_material_details_widgets/title_widget.dart';

class CollegePDFDetailsPage extends StatelessWidget {
  final int pos;

  const CollegePDFDetailsPage({
    @required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    PDFStateProvider pdfState = Provider.of<PDFStateProvider>(context, listen: false);
    CollegeMaterial collegeMaterial = pdfState.materials[pos];
    print('building Entire page widget');

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UpperPart(collegeMaterial, pos),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CollegeMaterialTitleWidget<PDFStateProvider>(
                        pos: pos,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      CollegeMaterialPublishedInWidget(publishingDate: pdfState.materials[pos].postDate),
                      if (pdfState.materials[pos].lastUpdate != null)
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                      if (pdfState.materials[pos].lastUpdate != null)
                        CollgeMaterialLastUpdateWidget<PDFStateProvider>(
                          pos: pos,
                        ),
                      SizedBox(
                        height: ScreenUtil().setHeight(50),
                      ),
                      CollegeMaterialDescriptionWidget<PDFStateProvider>(pos: pos),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                CollegeMaterialDetailsAuthorWidget<PDFStateProvider>(pos),
                SizedBox(
                  height: ScreenUtil().setHeight(70),
                ),
                CommentsSectionWidget<PDFStateProvider>(pos),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UpperPart extends StatelessWidget {
  final int pos;
  final CollegeMaterial collegeMaterial;

  _UpperPart(this.collegeMaterial, this.pos);

  @override
  Widget build(BuildContext context) {
    print('building Upper part widget');
    return GestureDetector(
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(100)),
            child: Center(
              child: Column(
                children: [
                  FaIcon(
                    FontAwesomeIcons.filePdf,
                    size: ScreenUtil().setHeight(280),
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(30),
                  ),
                  Text('Tap to open the file')
                ],
              ),
            ),
          ),
          onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
            RouteNames.OPEN_LECTURE_FILE,
            arguments: pos,
          ),
        ) ??
        Container(
          height: ScreenUtil().setHeight(550),
          //padding: EdgeInsets.all(ScreenUtil().setSp(20)),
          decoration: BoxDecoration(
              //color: Colors.yellow,
              image: DecorationImage(
                  image:
                      NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSqu6nZRUE2vC11mAjjaaPfVaZcDcb7BSYVw&usqp=CAU'),
                  fit: BoxFit.fill)),
          child: Container(
            // width: double.infinity,
            // height: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Text(
                'Tap Here To Open',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(60)),
              ),
            ),
          ),
        );
  }
}
