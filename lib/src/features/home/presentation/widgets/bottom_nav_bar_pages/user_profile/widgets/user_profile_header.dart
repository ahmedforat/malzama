import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/references/references.dart';
import '../../../../state_provider/profile_page_state_provider.dart';

String accountTypeMapper(String type) {
  switch (type) {
    case 'uniteachers':
      return 'University Lecturer';
      break;
    case 'unistudents':
      return 'University Student';
      break;
    case 'schteachers':
      return 'School Teacher';
      break;
    case 'schstudents':
      return 'School Student';
      break;
    default:
      return null;
  }
}

class UserProfileHeader2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);

    Widget coverPicture = InkWell(
      onTap: () async {
        await profilePageState.showOnCoverPictureTappingDialoge();
      },
      child: SizedBox(
        height: ScreenUtil().setHeight(400),
        width: double.infinity,
        child: Selector<ProfilePageState, File>(
          selector: (context, stateProvider) => stateProvider.coverPicture,
          builder: (context, coverPicture, _) => Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(ScreenUtil().setSp(15)), image: coverPicture == null ? null : DecorationImage(image: FileImage(coverPicture), fit: BoxFit.fill)),
              child: coverPicture == null
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Text('Add a cover photo'), Icon(Icons.add_a_photo)],
                      ),
                    )
                  : null),
        ),
      ),
    );

    Widget profilePhoto = InkWell(
      onTap: () async {
        // File newPhoto =
        //     await ImagePicker.pickImage(source: ImageSource.camera);
        // await profilePageState.updateProfilePicture(update: newPhoto);
        // print('photo saved successfully');
        profilePageState.target = 'profilePicture';
        await profilePageState.showOnProfilePictureTappingDialoge();
      },
      child: Selector<ProfilePageState, File>(
        selector: (context, stateProvider) => stateProvider.profilePicture,
        builder: (context, profilePicture, _) => Container(
          width: ScreenUtil().setWidth(230),
          height: ScreenUtil().setHeight(200),
          decoration: BoxDecoration(
              border: profilePageState.profilePicture != null ? Border.all(width: 2, color: Colors.black) : null,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(profilePageState.profilePicture == null ? 1100 : 15)),
              // shape: profilePageState.profilePicture != null ?BoxShape.circle:null,
              color: Colors.white,
              image: profilePageState.profilePicture == null
                  ? null
                  : DecorationImage(image: profilePageState.profilePicture != null ? FileImage(profilePageState.profilePicture) : AssetImage('assets/kaka.jpg'), fit: BoxFit.fill)),
          child: profilePageState.profilePicture != null
              ? null
              : Icon(
                  Icons.add_a_photo,
                  size: ScreenUtil().setSp(100),
                ),
          //child: Icon(Icons.add_a_photo,size: 50,),
        ),
      ),
    );

    // Personal Info Part
    Widget personalInfo = Selector<ProfilePageState, dynamic>(
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
              Text(
                '${userData.commonFields.firstName} ',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold),
              ),
              Text(
                '${userData.commonFields.lastName} ',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: ScreenUtil().setSp(50), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(15)),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Text(
              userData.commonFields.email,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(15)),
          Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child: Text(
              References.accountTypeDictionary[userData.commonFields.account_type],
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: ScreenUtil().setHeight(700),
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      child: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            coverPicture,
            Positioned(
              child: profilePhoto,
              top: ScreenUtil().setHeight(270),
              left: ScreenUtil().setWidth(50),
            ),
            Positioned(
              child: personalInfo,
              top: ScreenUtil().setHeight(470),
              left: ScreenUtil().setWidth(30),
            ),
            Positioned(
              child: IconButton(
                icon: FaIcon(FontAwesomeIcons.edit),
                onPressed: profilePageState.showDialogeOfEditingProfileData,
              ),
              top: ScreenUtil().setHeight(470),
              left: ScreenUtil().setWidth(900),
            ),
            // Positioned(
            //   child: IconButton(
            //     icon: Icon(Icons.ondemand_video),
            //     onPressed: () async {
            //       print('Hello Video');
            //       ContractResponse response = await Provider.of<SchoolUploadState>(context, listen: false).uploadNewVideo();
            //       if (response == null) {
            //         return;
            //       }
            //       if (response is Success) {
            //         await Provider.of<MaterialStateProvider>(context, listen: false).fetchMyVideosFromDB();
            //         locator<DialogService>().showDialogOfSuccess(message: response.message);
            //       } else {
            //         locator<DialogService>().showDialogOfFailure(message: response.message);
            //       }
            //     },
            //   ),
            //   top: ScreenUtil().setHeight(470),
            //   left: ScreenUtil().setWidth(700),
            // ),
            // Positioned(
            //   child: IconButton(
            //       icon: Icon(Icons.file_upload),
            //       onPressed: () async {
            //         ContractResponse response = await Provider.of<SchoolUploadState>(context, listen: false).uploadNewLecture();
            //         if (response == null) {
            //           return;
            //         }
            //         if (response is Success) {
            //           Provider.of<MaterialStateProvider>(context, listen: false).fetchMyPDFsFromDB();
            //           locator<DialogService>().showDialogOfSuccess(message: response.message);
            //         } else {
            //           locator<DialogService>().showDialogOfFailure(message: response.message);
            //         }
            //       }),
            //   top: ScreenUtil().setHeight(470),
            //   left: ScreenUtil().setWidth(500),
            // ),
            Positioned(
              child: IconButton(
                icon: Icon(Icons.explore),
                onPressed: () async {
                  Navigator.of(context).pushNamed('/quiz-uploader');
                },
              ),
              top: ScreenUtil().setHeight(470),
              left: ScreenUtil().setWidth(600),
            ),
          ],
        ),
      ),
    );
  }
}
