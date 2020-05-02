import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/platform/services/caching_services.dart';

class CoverPictureViewer extends StatefulWidget {
  @override
  _CoverPictureViewerState createState() => _CoverPictureViewerState();
}

class _CoverPictureViewerState extends State<CoverPictureViewer> {
  Future<File> _futureEvent() async {
    return File(await CachingServices.getField(key: 'coverPicture'));
  }

  Future _fetchCoverPicture;

  @override
  void initState() {
    super.initState();
    _fetchCoverPicture = _futureEvent();
  }

  @override
  Widget build(BuildContext context) {
    // ProfilePageState profilePageState = Provider.of<ProfilePageState>(context);

    return FutureBuilder(
      future: _fetchCoverPicture,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return CircularProgressIndicator();
        else
          return Scaffold(
            body: PhotoView(
              imageProvider: FileImage(snapshot.data),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.5,
            ),
          );
      },
    );
  }
}
