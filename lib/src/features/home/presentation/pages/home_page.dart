import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/debugging/debugging_widgets.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/usecases/log_out.dart';

class HomePage extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //  var state = Provider.of<CommonWidgetsStateProvider>(context,listen:false);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: <Widget>[
          SizedBox(
              width: 100,
              child: IconButton(
                  icon: Text('logOut'),
                  onPressed: () async {
                    ContractResponse response = await AccessManager.signOut();

                    if (response is SnackBarException) {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(response.message),
                        duration: Duration(seconds: 3),
                      ));
                      if(response is AuthorizationBreaking){
                        Future.delayed(Duration(seconds: 3));
                        Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (_) => false);
                      }
                    }else if(response is Success){
                       Navigator.of(context).pushNamedAndRemoveUntil('/signup-page', (_) => false);
                    }else{
                      DebugTools.showErrorMessageWidget(context: context, message: response.message);
                    }
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/signup-page', (_) => false);
                  })),
        ],
      ),
      body: Container(
        child: Center(child: Text('Welcome to Home Page')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(await FileSystemServices.getUserData());
        },
      ),
    );
  }
}
