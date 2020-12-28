import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:malzama/src/features/home/models/users/user.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:provider/provider.dart';

class PersonalInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Selector<UserInfoStateProvider, User>(
      selector: (context, stateProvider) => stateProvider.userData,
      builder: (context, userData, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(30)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: ScreenUtil().setWidth(30)),
              Selector<UserInfoStateProvider, String>(
                selector: (context, stateProvider) => stateProvider.userData.firstName,
                builder: (context, firstName, _) => Text(
                  '$firstName ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Selector<UserInfoStateProvider, String>(
                selector: (context, stateProvider) => stateProvider.userData.lastName,
                builder: (context, lastName, _) => Text(
                  '$lastName ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(15)),
          Selector<UserInfoStateProvider, String>(
            selector: (context, stateProvider) => stateProvider.userData.email,
            builder: (context, email, _) => Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
              child: Text(
                email,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(15)),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Text(
              References.accountTypeDictionary[userData.accountType],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
