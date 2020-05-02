import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/platform/services/caching_services.dart';

class ProfilePictureViewer extends StatefulWidget {
  @override
  _ProfilePictureViewerState createState() => _ProfilePictureViewerState();
}

class _ProfilePictureViewerState extends State<ProfilePictureViewer> {
  Future<File> _futureEvent() async {
    return File(await CachingServices.getField(key: 'profilePicture'));
  }
  Future _fetchProfilePicture;

  @override
  void initState() { 
    super.initState();
    _fetchProfilePicture = _futureEvent();
  }

  @override
  Widget build(BuildContext context) {
   // ProfilePageState profilePageState = Provider.of<ProfilePageState>(context);

    return FutureBuilder(
      future: _fetchProfilePicture,
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
