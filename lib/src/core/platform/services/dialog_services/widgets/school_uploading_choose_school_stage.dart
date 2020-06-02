import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/dialog_state_providers/school_uploads_state_provider.dart';
import 'package:malzama/src/core/references/references.dart';
import 'package:provider/provider.dart';
class TargetSchoolStage extends StatelessWidget {
  final List<FocusNode> focusNodes;

  TargetSchoolStage({@required this.focusNodes});

  @override
  Widget build(BuildContext context) {
    SchoolUploadState profilePageState = Provider.of<SchoolUploadState>(context, listen: false);
    ScreenUtil.init(context);
    return Selector<SchoolUploadState, String>(
      selector: (context, stateProvider) => stateProvider.targetStage,
      builder: (context, schoolStage, _) => GestureDetector(
        onTap: () => focusNodes.forEach((node) => node.unfocus()),
        child: Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        validator: (data) {
                          if (data == null)
                            return 'this field is required';
                          else
                            return null;
                        },
                        items: References.schoolStages.map((String stage) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              '$stage  ',
                              //style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: stage,
                          );
                        }).toList(),
                        onChanged: (update) {
                          print(update);
                          profilePageState.updateTargetStage(update);
                        },
                        value: profilePageState.targetStage,
                        hint: Align(alignment: Alignment.center, child: Text('Target stage')),
                        selectedItemBuilder: (BuildContext context) {
                          return References.schoolStages.map<Widget>((String item) {
                            return Align(
                                alignment: Alignment.center,
                                child: Text(
                                  item + ' ',
                                  textAlign: TextAlign.center,
                                ));
                          }).toList();
                        },
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}