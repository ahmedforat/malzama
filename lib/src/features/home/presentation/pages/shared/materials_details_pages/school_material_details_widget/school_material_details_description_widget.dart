import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../lectures_pages/state/material_state_repo.dart';

class SchoolMaterialDescriptionWidget<T extends MaterialStateRepository> extends StatefulWidget {
  final int pos;

  const SchoolMaterialDescriptionWidget({
    @required this.pos,
  });

  @override
  __DescriptionWidgetState createState() => __DescriptionWidgetState<T>();
}

class __DescriptionWidgetState<B extends MaterialStateRepository> extends State<SchoolMaterialDescriptionWidget> {
  bool _isBroken;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building description widget');
    ScreenUtil.init(context);
    MaterialStateRepository materialStateRepo = Provider.of<B>(context, listen: false);
    _isBroken = false ??materialStateRepo.materials[widget.pos].description.length > 350;
    return GestureDetector(
      onTap: () => setState(() => _isBroken = !_isBroken),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'some description',
              maxLines: _isBroken ? 4 : null,
              overflow: _isBroken ? TextOverflow.ellipsis : null,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(40),
              ),
            )??Selector<B, String>(
              selector: (context, stateProvider) => stateProvider.materials[widget.pos].description,
              builder: (context, description, _) => Container(
                //color: Colors.redAccent,
                child: Text(
                  description,
                  maxLines: _isBroken ? 4 : null,
                  overflow: _isBroken ? TextOverflow.ellipsis : null,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(40),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(35),
            ),
            GestureDetector(
              onTap: () => setState(() => _isBroken = !_isBroken),
              child: Text(_isBroken  ? 'قراءة المزيد' : 'اظهر القليل'),
            )
          ],
        ),
      ),
    );
  }
}
