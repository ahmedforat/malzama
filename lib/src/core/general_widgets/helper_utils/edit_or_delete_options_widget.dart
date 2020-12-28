import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class EditOrDeleteOptionWidget extends StatelessWidget {
  final String onEditText;
  final String onDeleteText;

  EditOrDeleteOptionWidget({
    String onEditText,
    String onDeleteText,
  })  : this.onEditText = onEditText ?? 'Edit',
        this.onDeleteText = onDeleteText ?? 'Delete';

  @override
  Widget build(BuildContext context) {
    UserInfoStateProvider userInfoStateProvider = Provider.of<UserInfoStateProvider>(context, listen: false);
    final String cancelText = userInfoStateProvider.isAcademic ? 'Cancel' : 'الغاء';
    ScreenUtil.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      height: ScreenUtil().setHeight(700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(ScreenUtil().setSp(60)),
          topLeft: Radius.circular(ScreenUtil().setSp(60)),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(380)),
            child: Container(
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(onEditText),
            onTap: () => Navigator.of(context).pop('edit'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text(onDeleteText),
            onTap: () => Navigator.of(context).pop('delete'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text(cancelText),
            onTap: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }
}
