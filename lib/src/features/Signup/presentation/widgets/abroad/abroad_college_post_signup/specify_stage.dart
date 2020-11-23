// import 'package:flutter/study_material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// import '../../../state_provider/abroad_college_state.dart';

// class SpecifyAbroadStageWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context);
//     return Padding(
//       padding: EdgeInsets.only(
//           left: ScreenUtil().setSp(200), right: ScreenUtil().setSp(200)),
//       child: Selector<AbroadCollegeState, List<String>>(
//         selector: (context, stateObject) =>
//             [stateObject.stageErrorMessage, stateObject.stage],
//         builder: (context, state, __) => TextFormField(
//           decoration: InputDecoration(
//             errorText: state[0],
//             labelText: 'Your Stage',
//           ),
//           onFieldSubmitted: (String value) {
//             AbroadCollegeState abroadCollegeState =
//                 Provider.of<AbroadCollegeState>(context, listen: false);
//             if (value == null || value.isEmpty) {
//               abroadCollegeState.updateStageErrorMessage(
//                   update: 'this field is required');
//             } else if (value.length < 5) {
//               abroadCollegeState.updateStageErrorMessage(
//                   update: 'this field must not be shorter than 5 characters');
//             } else {
//               abroadCollegeState.updateStageErrorMessage(update: null);
//               abroadCollegeState.updateStage(update: value);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
