import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BioOptionsWidget extends StatelessWidget {
  final bool forEdit;

  const BioOptionsWidget(this.forEdit);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(ScreenUtil().setSp(60)),
          topLeft: Radius.circular(ScreenUtil().setSp(60)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          ListTile(
            leading: Icon(forEdit ? Icons.edit : Icons.create),
            title: Text(forEdit ? 'Edit bio' : 'Add new bio'),
            onTap: () => Navigator.of(context).pop('edit'),
          ),
          Divider(),
          if (forEdit)
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete bio'),
              onTap: () => Navigator.of(context).pop('delete'),
            ),
          if (forEdit) Divider(),
          ListTile(
            leading: Icon(Icons.cancel),
            title: Text('Cancel'),
            onTap: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }
}
