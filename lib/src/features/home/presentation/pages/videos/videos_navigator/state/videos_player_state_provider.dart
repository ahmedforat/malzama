import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosPlayerStateProvider with ChangeNotifier {
  final List<DeviceOrientation> portrait = [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp];
  final List<DeviceOrientation> landscape = [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight];

  List<DeviceOrientation> freeMode;

  YoutubePlayerController _controller;

  YoutubePlayerController get youTubePlayerController => _controller;

  StudyMaterial _studyMaterial;

  StudyMaterial get studyMaterial => _studyMaterial;

  GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoadingTo(bool update) {
    _isLoading = update;
    notifyMyListeners();
  }

  VideosPlayerStateProvider(StudyMaterial studyMaterial) {
    setIsLoadingTo(true);
    _scaffoldKey = new GlobalKey<ScaffoldState>();
    _studyMaterial = studyMaterial;
    _controller = new YoutubePlayerController(
      initialVideoId: _studyMaterial.src,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        hideThumbnail: true,
        disableDragSeek: true,
      ),
    );

    freeMode = [...portrait, ...landscape];

    Future.delayed(Duration(seconds: 5)).then((value) => setIsLoadingTo(false));
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

  Widget screenResizingWidget(BuildContext context) => IconButton(
        icon: Icon(
          MediaQuery.of(context).orientation == Orientation.landscape ? Icons.fullscreen_exit : Icons.fullscreen,
          color: Colors.white,
        ),
        onPressed: () => _handleVideoOrientation(context),
      );

// handle the onPressed method of the resizing button
  void _handleVideoOrientation(BuildContext context) async {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final List<DeviceOrientation> nextOrientation = orientation == Orientation.portrait ? landscape : portrait;
    await setScreenOrientationTo(nextOrientation);
  }

// change the landscape to portrait when the back button gets pressed
  Future<bool> handleOnWillPop(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(portrait);
      return Future.value(false);
    }
    return Future.value(true);
  }



  String getTotalDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds - (minutes * 60);
    return ' $minutes:$secs';
  }

  Widget totalDurationWidget() {
    String _totalDurationWidget = getTotalDuration(_controller.metadata.duration.inSeconds);
    return Text(
      _totalDurationWidget == '0.0' ? '_:_' : getTotalDuration(_controller.metadata.duration.inSeconds),
      style: TextStyle(color: Colors.white),
    );
  }

  Future<void> setScreenOrientationTo(List<DeviceOrientation> orientations) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

// =================================================================================
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}
