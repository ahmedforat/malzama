import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/videos_navigator/state/videos_player_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../videos/widgets/info_overlay_widget.dart';

class VideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideosPlayerStateProvider playerStateProvider = Provider.of<VideosPlayerStateProvider>(context, listen: false);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      playerStateProvider.youTubePlayerController.play();
    });
    print('Building video player');
    return Selector<VideosPlayerStateProvider, bool>(
      selector: (context, stateProvider) => stateProvider.isLoading,
      builder: (context, isLoading, _) => isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : WillPopScope(
              onWillPop: () => playerStateProvider.handleOnWillPop(context),
              child: OrientationBuilder(
                builder: (context, orientation) => Scaffold(
                  key: playerStateProvider.scaffoldKey,
                  body: SizedBox.expand(
                    child: Container(
                      child: playerStateProvider.studyMaterial.src == null
                          ? Center(
                              child: Text('This Video is no longer availabe'),
                            )
                          : Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    height: orientation == Orientation.portrait ? screenHeight * 0.33 : screenHeight,
                                    width: screenWidth,
                                    child: YoutubePlayer(
                                      onEnded: (YoutubeMetaData metaData) {
                                        playerStateProvider.youTubePlayerController.play();
                                        playerStateProvider.youTubePlayerController.pause();
                                      },
                                      onReady: () {
                                        playerStateProvider.youTubePlayerController.play();
                                      },
                                      controller: playerStateProvider.youTubePlayerController,
                                      bottomActions: <Widget>[
                                        CurrentPosition(
                                          controller: playerStateProvider.youTubePlayerController,
                                        ),
                                        playerStateProvider.step10Forward(),
                                        ProgressBar(
                                          controller: playerStateProvider.youTubePlayerController,
                                          isExpanded: true,
                                          colors: ProgressBarColors(
                                            playedColor: Colors.red,
                                            handleColor: Colors.white,
                                            backgroundColor: Colors.white30,
                                          ),
                                        ),
                                        playerStateProvider.step10Backward(),
                                        Text(
                                          playerStateProvider.getTotalDuration(
                                                      playerStateProvider.youTubePlayerController.metadata.duration.inSeconds) ==
                                                  '0.0'
                                              ? '_:_'
                                              : playerStateProvider.getTotalDuration(
                                                  playerStateProvider.youTubePlayerController.metadata.duration.inSeconds),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        playerStateProvider.screenResizingWidget(context)
                                      ],
                                    ),
                                  ),
                                ),
                                if (orientation == Orientation.portrait)
                                  Positioned(
                                    top: ScreenUtil().setHeight(50),
                                    child: RaisedButton(
                                      child: Text('info'),
                                      onPressed: () {
                                        if (playerStateProvider.youTubePlayerController.value.isPlaying) {
                                          playerStateProvider.youTubePlayerController.pause();
                                        }
                                        showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (_) => CollegeVideoInfoOverlayWidget(playerStateProvider.studyMaterial));
                                      },
                                    ),
                                  )
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
