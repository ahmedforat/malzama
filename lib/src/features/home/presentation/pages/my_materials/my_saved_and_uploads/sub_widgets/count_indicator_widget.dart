import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/my_saved_and_uploads_contract.dart';
import 'package:provider/provider.dart';

class CountIndicatorWidget<T extends MySavedAndUploadsCommonState> extends StatelessWidget {
  final String text;
  final int count;
  final int tabIndex;

  const CountIndicatorWidget({
    @required this.text,
    @required this.count,
    @required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    T mySavedStateProvider = Provider.of<T>(context, listen: false);
    return Selector<T, int>(
      selector: (context, T stateProvider) => stateProvider.currentTabIndex,
      builder: (context, index, _) => GestureDetector(
        onTap: () async {
          if (mySavedStateProvider.currentTabIndex != tabIndex) {
            await mySavedStateProvider.animateToPage(tabIndex);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.linearToEaseOut,
          padding: EdgeInsets.all(ScreenUtil().setSp(tabIndex == index ? 20 : 15)),
          decoration: BoxDecoration(
            color: tabIndex == index ? Colors.redAccent : Colors.white,
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
            border: Border.all(color: Colors.transparent),
          ),
          child: Text(
            '$text: $count ',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(40),
              color: tabIndex == index ? Colors.white : Colors.black,
              fontWeight: tabIndex == index ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
