import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/state_provider/quiz_uploading_state_provider.dart';
import 'package:provider/provider.dart';

class QuizSemesterWidget<T extends StateProvider> extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    T uploadingState = Provider.of<T>(context,listen:false);
    return Selector<T,int>(
        selector: (context,stateProvider) => stateProvider.semester,
          builder:(context,_,__) => Padding(
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              //color: Colors.blueAccent,
              alignment: Alignment.center,
              width: 130,
              height: 50,
              child: RadioListTile(
                value: 1,
                groupValue: uploadingState.semester,
                onChanged: uploadingState.updateSemester,
                title: Text(
                  'First',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 150,
              height: 50,
              child: RadioListTile(
                value: 2,
                groupValue: uploadingState.semester,
                onChanged: uploadingState.updateSemester,
                title: Text(
                  'Second',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
