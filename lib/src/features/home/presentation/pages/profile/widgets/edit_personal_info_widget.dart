import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/profile/state_provider/edit_personal_info_state_provider.dart';
import 'package:provider/provider.dart';

class EditPersonalInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditPersonalInfoState infoState = Provider.of<EditPersonalInfoState>(context, listen: false);
    ScreenUtil.init(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: ScreenUtil().setHeight(1500),
          padding: EdgeInsets.all(ScreenUtil().setSp(50)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ScreenUtil().setSp(20)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.all(ScreenUtil().setSp(30)),
                    child: Text(
                      'Edit Personal Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(50),
                      ),
                    )),
                TextFieldWidget(infoState.firstNameController, 'FirstName', 0),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextFieldWidget(infoState.lastNameController, 'LastName', 1),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextFieldWidget(infoState.emailController, 'Email', 2),
                Selector<EditPersonalInfoState, bool>(
                  selector: (_, stateProvider) => stateProvider.isUpdating,
                  builder: (context, isUpdating, _) => isUpdating ? Container() : SizedBox(height: ScreenUtil().setHeight(150)),
                ),
                SizedBox(height: ScreenUtil().setHeight(400)),
                Selector<EditPersonalInfoState, bool>(
                  selector: (_, stateProvider) => stateProvider.isUpdating,
                  builder: (context, isUpdating, _) => AnimatedCrossFade(
                    crossFadeState: !isUpdating ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 150),
                    firstChild: Center(
                      child: Padding(
                        padding:  EdgeInsets.only(top:ScreenUtil().setSp(10)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: ScreenUtil().setHeight(60),
                            ),
                            Text('Updating .... please wait'),
                          ],
                        ),
                      ),
                    ),
                    secondChild: ActionsButtons(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final int pos;
  final TextEditingController controller;
  final String text;

  const TextFieldWidget(
    this.controller,
    this.text,
    this.pos,
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    EditPersonalInfoState infoState = Provider.of<EditPersonalInfoState>(context, listen: false);
    return Selector<EditPersonalInfoState, String>(
      selector: (context, stateProvider) => stateProvider.errorMessages[pos],
      builder: (context, errorMessage, _) => Container(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: text,
            errorText: errorMessage,
          ),
          onChanged: (_) => infoState.updateErrorMessage(pos, null),
        ),
      ),
    );
  }
}

class ActionsButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    EditPersonalInfoState infoState = Provider.of<EditPersonalInfoState>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RaisedButton(
          color: Colors.amber,
          onPressed: () async {
            Navigator.of(context).pop(null);
          },
          child: Text('Cancel'),
        ),
        SizedBox(width: ScreenUtil().setWidth(50)),
        RaisedButton(
          color: Colors.blueAccent,
          onPressed: () {
            infoState.onValidate(context);
          },
          child: Text(
            'Update',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
