import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:malzama/src/core/platform/local_database/access_objects/teacher_access_object.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/my_materials_state_provider.dart';
import '../../../../state_provider/profile_page_state_provider.dart';
import '../widgets/materials_widgets/material_holder_widget.dart';

class ExploreMaterialPage extends StatefulWidget {
  @override
  _ExploreMaterialPageState createState() => _ExploreMaterialPageState();
}

class _ExploreMaterialPageState extends State<ExploreMaterialPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProfilePageState profilePageState =
        Provider.of<ProfilePageState>(context, listen: false);
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(25)),
            child: ListView(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(300),
                  child: _upperPart(profilePageState),
                ),
                TabBar(controller: _tabController, tabs: [
                  Tab(
                    icon: FaIcon(
                      FontAwesomeIcons.youtube,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Tab(
                    icon: FaIcon(FontAwesomeIcons.filePdf,
                        color: Colors.blueAccent),
                  ),
                ]),
                SizedBox(
                  height: ScreenUtil().setHeight(1300),
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        Container(
                          child: VideoListView(),
                        ),
                        Container(child: PDFListView())
                      ]),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: ScreenUtil().setSp(80),
          ),
          onPressed: () {
            TeacherAccessObject().fetchAllVideos().then((videos){
              videos.forEach((f) => print(f.toJSON()));
            });


          },
        ),
      ),
    );
  }

  Widget _upperPart(ProfilePageState profileState) {
    return Selector<MyMaterialStateProvider, List<int>>(
      selector: (context, stateProvider) =>
          [stateProvider.myPDFs.length, stateProvider.myVideos.length],
      builder: (context, uploads, _) => Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              References.isTeacher(profileState)
                  ? 'My uploaded materials'
                  : 'My saved materials',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(80),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Row(
              children: <Widget>[
                Text(
                  '${uploads[1]} videos',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(30),
                ),
                Text(
                  '${uploads[0]} lectures',
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PDFListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyMaterialStateProvider materialStateProvider =
        Provider.of<MyMaterialStateProvider>(context);
    return Material(
      color: Colors.grey[300],
      child: materialStateProvider.myPDFs == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : materialStateProvider.myPDFs.length == 0
              ? Center(
                  child: Text('There are no lectures uploaded yet',
                      style: TextStyle(fontSize: ScreenUtil().setSp(50))),
                )
              : ListView.builder(
                  itemCount: materialStateProvider.myPDFs.length,
                  itemBuilder: (context, pos) => SchoolMaterialWidget(
                        pos: pos,
                        isVideo: false,
                      )),
    );
  }
}

class VideoListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyMaterialStateProvider materialStateProvider =
        Provider.of<MyMaterialStateProvider>(context);
    return Material(
      child: materialStateProvider.myVideos == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : materialStateProvider.myVideos.length == 0
              ? Center(
                  child: Text('There are no videos uploaded yet',
                      style: TextStyle(fontSize: ScreenUtil().setSp(50))),
                )
              : ListView.builder(
                  itemCount: materialStateProvider.myVideos.length,
                  itemBuilder: (context, pos) => SchoolMaterialWidget(
                        pos: pos,
                        isVideo: true,
                      )),
    );
  }
}
