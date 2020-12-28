import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/videos_player_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import '../college_material_details_widgets/author_widget.dart';
import '../college_material_details_widgets/college_material_last_update_widget.dart';
import '../college_material_details_widgets/college_material_published_in_widget.dart';
import '../college_material_details_widgets/comments_section_widget.dart';
import '../college_material_details_widgets/description_widget.dart';
import '../college_material_details_widgets/title_widget.dart';
import '../players/video_player/video_player_widget.dart';

class CollegeVideoDetailsPage<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const CollegeVideoDetailsPage({@required this.pos});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    B pdfState = Provider.of<B>(context, listen: false);
    print('building Entire page widget');
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(ScreenUtil().setSp(30)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UpperPart<B>(pos),
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
                      CollegeMaterialTitleWidget<B>(
                        pos: pos,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      CollegeMaterialPublishedInWidget(publishingDate: pdfState.materials[pos].postDate ?? null),
                      if (pdfState.materials[pos].lastUpdate != null)
                        SizedBox(
                          height: ScreenUtil().setHeight(20),
                        ),
                      if (pdfState.materials[pos].lastUpdate != null) CollgeMaterialLastUpdateWidget<B>(pos: pos),
                      SizedBox(
                        height: ScreenUtil().setHeight(50),
                      ),
                      CollegeMaterialDescriptionWidget<B>(pos: pos),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                CollegeMaterialDetailsAuthorWidget<B>(pos),
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                CommentsSectionWidget<B>(pos),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UpperPart<B extends MaterialStateRepository> extends StatelessWidget {
  final int pos;

  const _UpperPart(this.pos);

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
                FontAwesomeIcons.youtube,
                size: ScreenUtil().setHeight(280),
                color: Colors.red,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              Text('Tap to Play the video')
            ],
          ),
        ),
      ),
      onTap: () {
        StudyMaterial studyMaterial = Provider.of<B>(context, listen: false).materials[pos];

        WidgetBuilder builder = (context) => ChangeNotifierProvider<VideosPlayerStateProvider>(
              create: (context) => VideosPlayerStateProvider(studyMaterial),
              builder: (context, _) => VideoPlayer(),
            );
        Navigator.of(context, rootNavigator: true).push(new MaterialPageRoute(builder: builder));
      },
    );
  }
}
