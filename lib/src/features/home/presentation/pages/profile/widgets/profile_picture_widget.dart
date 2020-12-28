import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:provider/provider.dart';

class ProfilePictureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);
    return InkWell(
      onTap: () async {
        HelperFucntions.showProfilePicturesModalSheet(context: context, pictureName: 'profile');
      },
      child: Selector<ProfilePageState, File>(
        selector: (context, stateProvider) => stateProvider.profilePicture,
        builder: (context, profilePicture, _) => Container(
          width: ScreenUtil().setWidth(230),
          height: ScreenUtil().setHeight(230),
          decoration: BoxDecoration(
              color: Colors.white,
              border: profilePicture != null ? Border.all(width: 2, color: Colors.black) : null,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(profilePageState.profilePicture == null ? 1100 : 15)),
              // shape: profilePageState.profilePicture != null ?BoxShape.circle:null,

              image: profilePageState.profilePicture == null
                  ? null
                  : DecorationImage(
                      image: profilePageState.profilePicture != null
                          ? FileImage(profilePageState.profilePicture)
                          : AssetImage('assets/kaka.jpg'),
                      fit: BoxFit.fill)),
          child: profilePageState.profilePicture != null
              ? null
              : Icon(
                  Icons.add_a_photo,
                  size: ScreenUtil().setSp(100),
                  color: Colors.black,
                ),
          //child: Icon(Icons.add_a_photo,size: 50,),
        ),
      ),
    );
  }
}
