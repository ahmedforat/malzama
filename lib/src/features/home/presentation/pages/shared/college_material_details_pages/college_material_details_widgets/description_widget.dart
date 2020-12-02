import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/lectures_pages/state/material_state_repo.dart';
import 'package:provider/provider.dart';

class CollegeMaterialDescriptionWidget<T extends MaterialStateRepo> extends StatefulWidget {
  final int pos;

  const CollegeMaterialDescriptionWidget({
    @required this.pos,
  });

  @override
  __DescriptionWidgetState createState() => __DescriptionWidgetState<T>();
}

class __DescriptionWidgetState<B extends MaterialStateRepo> extends State<CollegeMaterialDescriptionWidget> {
  bool _isBroken;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building description widget');
    ScreenUtil.init(context);
    MaterialStateRepo materialStateRepo = Provider.of<B>(context, listen: false);
    final bool shouldBeBreaked = materialStateRepo.materials[widget.pos].description.length > 350;
    _isBroken = shouldBeBreaked;

    print(materialStateRepo.materials[widget.pos].description);
    return GestureDetector(
      onTap: () => setState(() => _isBroken = !_isBroken),
      child: Container(
        padding: EdgeInsets.only(left: ScreenUtil().setSp(50)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<B, String>(
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
            if(shouldBeBreaked)
            GestureDetector(
              onTap: () => setState(() => _isBroken = !_isBroken),
              child: Text( _isBroken  ? 'show more' : 'show less'),
            )
          ],
        ),
      ),
    );
  }
}
