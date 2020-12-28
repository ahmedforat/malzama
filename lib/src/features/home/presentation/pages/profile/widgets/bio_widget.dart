import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/state_provider/edit_bio_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/widgets/edit_bio_widget.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/small_circular_progress_indicator.dart';
import 'package:malzama/src/features/home/presentation/state_provider/profile_page_state_provider.dart';
import 'package:provider/provider.dart';

class BioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ProfilePageState profilePageState = Provider.of<ProfilePageState>(context, listen: false);
    return Container(
      //padding: EdgeInsets.all(ScreenUtil().setSp(30)),
      height: ScreenUtil().setHeight(400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
      ),
      alignment: Alignment.center,
      child: SizedBox.expand(
        child: FlatButton(
          onPressed: () async {
            final bool forEdit = profilePageState.bio != null;
            final String res = await HelperFucntions.showBioModalSheet(context: context,forEdit: forEdit);
            if (res == null) return;
            if (res == 'edit') {
              var result = await showBioEditWidget(context,profilePageState.bio);
              if (result == null) return;
              if (result.first == true) {
                print('result is true');
                profilePageState.updateBio(result.last);
                profilePageState.showSnackBar(message: 'Done: Bio updated');
              }
            } else {
              profilePageState.deleteBio(context);
            }
          },
          child: Selector<ProfilePageState, List>(
            selector: (context, stateProvider) => [
              stateProvider.bio,
              stateProvider.isDeletingBio,
            ],
            builder: (context, data, _) {
              if (data.last) {
                return SmallCircularProgressIndicator();
              }

              if (data.first == null) {
                return Text(
                  'Tap to add Bio',
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              }
              return Padding(
                padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                child: Text(
                  data.first,
                  textAlign: TextAlign.center,
                  maxLines: 5,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

showBioEditWidget(BuildContext context,String bio) async {
  bool edit = bio != null;
  return await showModalBottomSheet(
    backgroundColor: Colors.transparent,
    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setSp(20))),
    isScrollControlled: true,
    context: context,
    builder: (_) => ChangeNotifierProvider<EditBioStateProvider>(
      create: (context) => EditBioStateProvider(edit,bio: bio),
      builder: (context, _) => EditBioWidget(),
    ),
  );
}
