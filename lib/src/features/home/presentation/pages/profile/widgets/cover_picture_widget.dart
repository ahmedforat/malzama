import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/small_circular_progress_indicator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:provider/provider.dart';

class ProfileCoverPictureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);
    return InkWell(
      onTap: () async {
        if (profilePageState.isCoverPictureClickable) {
          final bool enableDelete = profilePageState.coverPicture != null;
          print('deleteEnabled = $enableDelete');
          var value = await HelperFucntions.showProfilePicturesModalSheet(
            context: context,
            pictureName: 'cover',
            enableDelete: enableDelete,
          );
          profilePageState.onCoverPictureOptionsHandler(context, value);
        }
      },
      child: Hero(
        tag: 'cover',
        child: SizedBox(
          height: ScreenUtil().setHeight(400),
          width: double.infinity,
          child: Selector<ProfilePageState, File>(
            selector: (context, stateProvider) => stateProvider.coverPicture,
            builder: (context, coverPicture, _) => Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setHeight(300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(15)),
                image: DecorationImage(
                  image: coverPicture == null ? AssetImage(profilePageState.defaultCoverPicture) : FileImage(coverPicture),
                  fit: BoxFit.fill,
                ),
              ),
              child: Selector<ProfilePageState, List<dynamic>>(
                selector: (context, stateProvider) => [
                  stateProvider.isUploadingCoverPicture,
                  stateProvider.coverPicture,
                  stateProvider.isDeletingCoverPicture,
                ],
                builder: (_, data, __) {
                  if (data.first || data.last) {
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(ScreenUtil().setSp(50)),
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: SmallCircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                  if (data[1] != null) {
                    return Container();
                  }

                  return Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: ScreenUtil().setWidth(450),
                      padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Add a cover photo'),
                          Icon(Icons.add_a_photo),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
