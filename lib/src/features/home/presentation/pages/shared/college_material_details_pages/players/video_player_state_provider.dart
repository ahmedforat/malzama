import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerStateProvider with ChangeNotifier {
  // ==================================================================================
  // within the rootNavigator to know whether the video is full screen or not
  bool _withinRootNavigator = false;

  bool get withinRootNavigator => _withinRootNavigator;

  void setWithinRootNavigatorTo(bool update) {
    this._withinRootNavigator = update;
    notifyMyListeners();
  }

  // =====================================================================================

  YoutubePlayerController _playerController;

  YoutubePlayerController get playerController => _playerController;
  String _videoId;

  String get videoId => _videoId;

  void setVideoId(String videoId) {
    _videoId = videoId;
    notifyMyListeners();
  }



  bool _isDisposed = false;
  bool _isPlayerControllerDisposed;

  bool get isPlayerControllerDisposed => _isPlayerControllerDisposed;


  void disposePlayerController() {
    if (!_isPlayerControllerDisposed) {
      _playerController.dispose();
      _isPlayerControllerDisposed = true;
      _videoId = null;
    }
  }

  void initializePlayerController(String videoId) {
    _videoId = videoId;
    _playerController = new YoutubePlayerController(
      initialVideoId: _videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        disableDragSeek: true,
        hideThumbnail: true,
        enableCaption: true,
      ),
    );
    _isPlayerControllerDisposed = false;
  }

  void handleWhenNavingToAnotherScreenMode() {
    _playerController.seekTo(Duration(seconds: getSuitableStartPosition()));
    _playerController.pause();
  }


  int getSuitableSeteppingForward() {
    if (_playerController.value.metaData.duration.inSeconds - _playerController.value.position.inSeconds > 10) {
      return _playerController.value.position.inSeconds + 10;
    } else {
      return _playerController.value.metaData.duration.inSeconds - 1;
    }
  }

  int getSuitableSeteppingBackward() {
    if (_playerController.value.position.inSeconds > 10) {
      return _playerController.value.position.inSeconds - 10;
    } else {
      return 0;
    }
  }

  int getSuitableStartPosition() => _playerController.value.position.inSeconds - 2;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _playerController?.dispose();
    _isDisposed = true;
    super.dispose();
  }
}
