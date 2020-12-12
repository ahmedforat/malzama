import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressorWidget extends StatefulWidget {
  @override
  _ImageCompressorWidgetState createState() => _ImageCompressorWidgetState();
}

class _ImageCompressorWidgetState extends State<ImageCompressorWidget> {
  File pickedImage;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final imgurl =
        'https://firebasestorage.googleapis.com/v0/b/malzama-platform.appspot.com/o/searched_products%2Fss.jpeg?alt=media&token=6894c2cd-7dcf-42df-b826-ad1bbfaf470e';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (pickedImage != null) Image.file(pickedImage),
              SizedBox(height: 60),
              RaisedButton(
                child: Text('Pick an image'),
                onPressed: () async {
                  PickedFile image = await ImagePicker().getImage(
                    source: ImageSource.gallery,
                  );

                  var dir = await getApplicationDocumentsDirectory();

                  var compressedImage = await FlutterImageCompress.compressAndGetFile(File(image.path).path, dir.path + 'name.jpeg',
                      format: CompressFormat.jpeg, quality: 10);
                  print('normal image size = ${File(image.path).lengthSync()}');
                  print('compressed image size = ${compressedImage.lengthSync()}');

                  print('=================================================');
                  print('==================================================');
                  print(compressedImage.lengthSync());
                  print('=================================================');
                  print('==================================================');
                  print('the image displayed is the normal one');
                  setState(() {
                    pickedImage = new File(image.path);
                  });

                  var dataSnapShot = await storage.ref().child('searched_products/ss.jpeg').putFile(compressedImage).onComplete;

                  print('image uploaded successfully to firebase storage');
                  print(await dataSnapShot.ref.getDownloadURL());

                  await Future.delayed(Duration(seconds: 20));
                  setState(() {
                    pickedImage = new File(compressedImage.path);
                  });
                  print('the image displayed is the compressed one');
                },
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
