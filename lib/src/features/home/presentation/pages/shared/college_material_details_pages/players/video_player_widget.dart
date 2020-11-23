import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:malzama/src/core/platform/services/dialog_services/service_locator.dart';
import 'package:malzama/src/features/home/presentation/pages/shared/college_material_details_pages/details_pages/college_pdf_details_page.dart';
import 'package:malzama/src/features/home/presentation/pages/videos/widgets/info_overlay_widget.dart';
import 'package:malzama/src/features/home/presentation/state_provider/user_info_provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoId;

  const VideoPlayer({@required this.videoId});

  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

Map<bool, double> rotationValues = {true: pi / 2, false: 0.0};

class _VideoDisplayState extends State<VideoPlayer> {
  final List<DeviceOrientation> portrait = [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp];
  final List<DeviceOrientation> landscape = [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight];

  List<DeviceOrientation> freeMode;

  String totalDuration;
  YoutubePlayerController _controller;

  bool _rotationAngle = false;
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    super.initState();
    freeMode = [...portrait, ...landscape];

    scaffoldKey = new GlobalKey<ScaffoldState>();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId ?? 'wBA4jq47xRs',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        hideThumbnail: true,
        disableDragSeek: true,
      ),
    );
  }

//
//  void playingStatusListener(){
//    if(_controller.value.position.inSeconds == _controller.metadata.duration.inSeconds){
//      _controller.pause();
//    }
//  }

  @override
  void dispose() {
    //   _controller.removeListener(playingStatusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_controller.load(ModalRoute.of(context).settings.arguments);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;



    return WillPopScope(
      onWillPop: _handleOnWillPop,
      child: OrientationBuilder(

        builder:(context,orientation) =>  Scaffold(
          key: scaffoldKey,
          body: SizedBox.expand(
            child: Container(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      height: orientation == Orientation.portrait ? screenHeight * 0.33 : screenHeight,
                      width: screenWidth,
                      child: YoutubePlayer(
                        onEnded: (YoutubeMetaData metaData) {
                          _controller.play();
                          _controller.pause();
                        },
                        onReady: () {
//                _controller.addListener(() {
//                  print(_controller.metadata.duration.inSeconds);
//                  print(_controller.value.position.inSeconds);
//                });
                        },
                        controller: _controller,
                        bottomActions: <Widget>[
                          CurrentPosition(
                            controller: _controller,
                          ),
                          step10Forward(),
                          ProgressBar(
                            controller: _controller,
                            isExpanded: true,
                            colors: ProgressBarColors(playedColor: Colors.red, handleColor: Colors.white, backgroundColor: Colors.white30),
                          ),
                          step10Backward(),
                          Text(
                            _getTotalDuration(_controller.metadata.duration.inSeconds) == '0.0'
                                ? '_:_'
                                : _getTotalDuration(_controller.metadata.duration.inSeconds),
                            style: TextStyle(color: Colors.white),
                          ),
                          screenResizingWidget()
                        ],
                      ),
                    ),
                  ),
                  if(orientation == Orientation.portrait)Positioned(
                    top: ScreenUtil().setHeight(50),
                    child: RaisedButton(
                      child: Text('info'),
                      onPressed: () {
                        if(_controller.value.isPlaying){
                          _controller.pause();
                        }
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => VideoInfoOverlayWidget(0)??Container(
                            height: ScreenUtil().setHeight(1500),
                            color: Colors.red,
                            child: Center(child: Text('This is the best video ever',style: TextStyle(color: Colors.white),)),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget step10Forward() => IconButton(
        icon: Icon(
          MaterialIcons.forward_10,
          color: Colors.white,
        ),
        onPressed: () {
          if (!_controller.value.isPlaying) {
            _controller.seekTo(Duration(seconds: _getSuitableSeteppingForward()));
            _controller.pause();
          } else {
            _controller.seekTo(Duration(seconds: _getSuitableSeteppingForward()));
          }
        },
      );

  Widget step10Backward() => IconButton(
        icon: Icon(MaterialIcons.replay_10, color: Colors.white),
        onPressed: () {
          if (!_controller.value.isPlaying) {
            _controller.seekTo(Duration(seconds: _getSuitableSeteppingBackward()));
            _controller.pause();
          } else {
            _controller.seekTo(Duration(seconds: _getSuitableSeteppingBackward()));
          }
        },
      );

  int _getSuitableSeteppingForward() {
    if (_controller.value.metaData.duration.inSeconds - _controller.value.position.inSeconds > 10) {
      return _controller.value.position.inSeconds + 10;
    } else {
      return _controller.value.metaData.duration.inSeconds - 1;
    }
  }

  int _getSuitableSeteppingBackward() {
    if (_controller.value.position.inSeconds > 10) {
      return _controller.value.position.inSeconds - 10;
    } else {
      return 0;
    }
  }

  Widget screenResizingWidget() => IconButton(
        icon: Icon(
          MediaQuery.of(context).orientation == Orientation.landscape ? Icons.fullscreen_exit : Icons.fullscreen,
          color: Colors.white,
        ),
        onPressed: _handleVideoOrientation,
      );

// handle the onPressed method of the resizing button
  void _handleVideoOrientation() async {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final List<DeviceOrientation> nextOrientation = orientation == Orientation.portrait ? landscape : portrait;
    await setScreenOrientationTo(nextOrientation);

  }

// change the landscape to portrait when the back button gets pressed
  Future<bool> _handleOnWillPop() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(portrait);
      return Future.value(false);
    }
    return Future.value(true);
  }

  String _getTotalDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds - (minutes * 60);
    return ' $minutes:$secs';
  }

  Widget _totalDurationWidget() {
    String _totalDurationWidget = _getTotalDuration(_controller.metadata.duration.inSeconds);
    return Text(
      _totalDurationWidget == '0.0' ? '_:_' : _getTotalDuration(_controller.metadata.duration.inSeconds),
      style: TextStyle(color: Colors.white),
    );
  }

  Future<void> setScreenOrientationTo(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }
}


