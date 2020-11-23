import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../core/references/references.dart';
import '../../state_providers/school_uploads_state_provider.dart';


class TargetSchoolSection extends StatelessWidget {
  final List<FocusNode> focusNodes;

  TargetSchoolSection({@required this.focusNodes});

  @override
  Widget build(BuildContext context) {
    SchoolUploadState profilePageState = Provider.of<SchoolUploadState>(context, listen: false);


    ScreenUtil.init(context);
    return Selector<SchoolUploadState, String>(
      selector: (context, stateProvider) => stateProvider.targetSchoolSection,
      builder: (context, schoolStage, _) => GestureDetector(
        onTap: () => focusNodes.forEach((node) => node.unfocus()),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
                        items: References.schoolSections.map((String section) {
                          return DropdownMenuItem<String>(
                            child: Text(
                              section.trim(),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              //style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: section,
                          );
                        }).toList(),
                        onChanged: (update) {
                          print(update);
                          profilePageState.updateTargetSchoolSection(update);
                        },
                        value: profilePageState.targetSchoolSection,
                        hint: Align(alignment: Alignment.center, child: Text('Target section')),
                        // selectedItemBuilder: (BuildContext context) {
                        //   return References.schoolSections.map<Widget>((String item) {
                        //     return Align(
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           item.trim() ,
                        //           textAlign: TextAlign.right

                        //         ));
                        //   }).toList();
                        // },
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