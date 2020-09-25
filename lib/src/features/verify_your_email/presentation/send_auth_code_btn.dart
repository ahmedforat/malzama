import 'package:flutter/material.dart';
import 'package:malzama/src/core/style/colors.dart';
import 'package:malzama/src/features/Signup/presentation/state_provider/execution_state.dart';
import 'package:malzama/src/features/Signup/usecases/signup_usecase.dart';
import 'package:provider/provider.dart';

class SendAuthCodeButton extends StatelessWidget {
  final Future<void> Function(BuildContext,ExecutionState) onPressed;

  SendAuthCodeButton({@required this.onPressed});
  @override
  Widget build(BuildContext context) {
    ExecutionState state = Provider.of<ExecutionState>(context);
    return RaisedButton(
        color: MalzamaColors.appBarColor,
        child: state.isLoading
            ? CircularProgressIndicator()
            : Text(
          'OK',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async => await onPressed(context,state)
    );
  }
}
