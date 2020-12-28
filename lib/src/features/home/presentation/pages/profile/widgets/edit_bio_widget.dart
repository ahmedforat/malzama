import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/state_provider/edit_bio_state_provider.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/accessory_widgets/small_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class EditBioWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    EditBioStateProvider editBioStateProvider = Provider.of<EditBioStateProvider>(context, listen: false);
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Container(
        height: ScreenUtil().setHeight(1200),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(ScreenUtil().setSp(25)), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(60),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(30)),
              child: Text(
                editBioStateProvider.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(60),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(60),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(50)),
              child: Selector<EditBioStateProvider, String>(
                selector: (context, stateProvider) => stateProvider.errorText,
                builder: (context, errorText, _) => TextField(
                  maxLength: 130,
                  maxLines: 5,
                  controller: editBioStateProvider.bioController,
                  onChanged: editBioStateProvider.onChanged,
                  decoration: InputDecoration(
                    errorText: errorText,
                    hintText: 'Type here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(200),
            ),
            Center(
              child: Selector<EditBioStateProvider, bool>(
                selector: (context, stateProvider) => stateProvider.isUpdatingBio,
                builder: (context, isUpdating, _) => isUpdating
                    ? SmallCircularProgressIndicator()
                    : RaisedButton(
                        color: Colors.blueAccent,
                        onPressed: () => editBioStateProvider.editBio(context),
                        child: Text(
                          'Save and upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
