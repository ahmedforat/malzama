import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/image_resource_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/modal_sheet_top_holder_widget.dart';

class ProfilePicturesModalSheet extends StatefulWidget {
  final String onEditText;
  final String onDeleteText;
  final String onViewText;
  final deleteEnabled;

  ProfilePicturesModalSheet({String onEditText, String onDeleteText, String onViewText, bool deleteEnabled = false})
      : this.onEditText = onEditText ?? 'Edit',
        this.onDeleteText = onDeleteText ?? 'Delete',
        this.onViewText = onViewText ?? 'View',
        this.deleteEnabled = deleteEnabled;

  @override
  _ProfilePicturesModalSheetState createState() => _ProfilePicturesModalSheetState();
}

class _ProfilePicturesModalSheetState extends State<ProfilePicturesModalSheet> {
  PageController _pageController;
  bool isShowingImageSources = false;

  @override
  void initState() {
    _pageController = new PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    List<Widget> optionsWidgets = [
      SizedBox(
        height: ScreenUtil().setHeight(30),
      ),
      ModalSheetTopHolder(),
      SizedBox(
        height: ScreenUtil().setHeight(30),
      ),
      if (widget.deleteEnabled) ...[
        ListTile(
          leading: Icon(Icons.remove_red_eye),
          title: Text(widget.onViewText),
          onTap: () => Navigator.of(context).pop('view'),
        ),
        Divider(),
      ],
      ListTile(
        leading: Icon(Icons.upload_outlined),
        title: Text(widget.onEditText),
        onTap: () => _pageController.animateToPage(
          1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      ),
      if (widget.deleteEnabled) ...[
        Divider(),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text(widget.onDeleteText),
          onTap: () => Navigator.of(context).pop('delete'),
        ),
      ],
      Divider(),
      ListTile(
        leading: Icon(Icons.cancel),
        title: Text('Cancel'),
        onTap: Navigator.of(context).pop,
      ),
    ];

    print(widget.deleteEnabled);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      height: ScreenUtil().setHeight(widget.deleteEnabled || isShowingImageSources ? 890 : 470),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(ScreenUtil().setSp(60)),
          topLeft: Radius.circular(ScreenUtil().setSp(60)),
        ),
      ),
      child: PageView(
        onPageChanged: (pos) {
          setState(() {
            isShowingImageSources = pos == 1;
          });
        },
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: optionsWidgets,
          ),
          ImageResourceWidget(_pageController),
        ],
      ),
    );
  }
}
