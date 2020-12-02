import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/players/pdf_player/pdf_player_state_provider.dart';
import 'package:provider/provider.dart';

class PDFPlayerWidget extends StatelessWidget {
  const PDFPlayerWidget();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Selector<PDFPlayerStateProvider, List<dynamic>>(
      selector: (context, stateProvider) => [
        stateProvider.path,
        stateProvider.isLoading,
        stateProvider.failedToLoad,
      ],
      builder: (context, data, child) {
        if (data[0] != null) {
          return PDFViewerScaffold(
            path: data[0],
          );
        }

        if (data[1] as bool) {
          return FileLoadingWidget();
        }

        return FailedToLoadFileWidget();
      },
    );
  }
}

class FailedToLoadFileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to Load File'),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              RaisedButton(
                child: Text('Reload'),
                onPressed: () {
                  PDFPlayerStateProvider playerStateProvider = Provider.of<PDFPlayerStateProvider>(context, listen: false);
                  playerStateProvider.initialize();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FileLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Selector<PDFPlayerStateProvider, double>(
      selector: (context, stateProvider) => stateProvider.progress,
      builder: (context, loadedSize, _){
        print('building progress indicator');
        return Scaffold(
            body: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(70)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Loading file ... ${(loadedSize * 100).toInt()} %'),
                    SizedBox(
                      height: ScreenUtil().setHeight(50),
                    ),

                    LinearProgressIndicator(
                      value: loadedSize,
                      backgroundColor: Colors.black12,
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }
}
