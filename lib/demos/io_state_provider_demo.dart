import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IOStateProviderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    IOStateProvider ioStateProvider = Provider.of<IOStateProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Text('test'), onPressed: (){

          })
        ],
      ),
        body: Container(
          child: Center(
            child: Selector<IOStateProvider, int>(
              selector: (context, stateProvider) => stateProvider.stateMap['upload_new_pdf'].uploaded,
              builder: (context, uploaded, _) {
                print('rebuilding');
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (ioStateProvider.isUploadDone)
                        Text(
                          'Upload Completed',
                        ),
                      Text((ioStateProvider.stateMap['upload_new_pdf'].percent * 100).toInt().toString() + ' %'),
                      SizedBox(height: 50),
                      LinearProgressIndicator(
                        value: ioStateProvider.stateMap['upload_new_pdf'].percent,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: Row(
          children: [
            SizedBox(width: 40),
            RaisedButton(
              child: Text('PDF'),
              onPressed: Provider.of<IOStateProvider>(context, listen: false).setPDFUploaded,
            ),
            SizedBox(width: 20),
            RaisedButton(
              child: Text('UPLOAD'),
              onPressed: Provider.of<IOStateProvider>(context, listen: false).uploadDataData,
            ),
          ],
        ));
  }
}

class IOStateProvider with ChangeNotifier {
  bool get isUploadDone => stateMap['upload_new_pdf'].total == stateMap['upload_new_pdf'].uploaded;

  Map<String, UseCase> stateMap = {
    'upload_new_pdf': UseCase(total: json.encode(data).length, uploaded: 0),
    'upload_new_video': UseCase(total: 421, uploaded: 51)
  };

  void setPDFUploaded({int update}) {
    print('updating');
    print(update);
    stateMap['upload_new_pdf'].uploaded = update;
    notifyListeners();
  }

  void setVideoUploaded() {
    stateMap['upload_new_video'].uploaded += 1;
    notifyListeners();
  }

  Future<void> uploadDataData() async {
    Response d = await Dio().post(
      'http://10.0.2.2:3000/testing/post-something',
      data: data,
      onSendProgress: (progress,total) {
        //await Future.delayed(Duration(milliseconds: 1000));
        setPDFUploaded(update: progress);
      },
    );
    print('done');
    print(d.statusCode);
  }

  Future<void> uploadData() async {
    print('uploading');
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.postUrl(Uri.parse('http://10.0.2.2:3000/testing/post-something'));
    request.headers.contentLength = json.encode(data).length;
    request.contentLength = json.encode(data).length;
    request.headers.contentType = ContentType.json;
    request.write(json.encode(data));

    HttpClientResponse response = await request.close();
    response
        .transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          setPDFUploaded(update: data.length);
          sink.add(data);
          print('========================================================================');
          print('uploaded : ${stateMap['upload_new_pdf'].uploaded}');
          print('total: ${stateMap['upload_new_pdf'].total}');
          print('percent : ${stateMap['upload_new_pdf'].percent}');
          print('========================================================================');
        },
        handleDone: (sink) {
          sink.close();
          print('upload done');
        },
        handleError: (err, stackTrace, sink) {
          throw err;
        },
      ),
    )
        .listen(
      (event) {},
      onDone: () {
        print('Upload Completed');
      },
    );
  }
}

class UseCase {
  int total;
  int uploaded;

  double get percent => double.parse((uploaded / total).toStringAsFixed(2));

  UseCase({this.total, this.uploaded});
}

Map<String, dynamic> data = {
  'name': 'Karrar Mohammed',
  'age': 27,
  'career': 'software engineer',
  'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
  'birthDate': '17/05/1993',
  'co-worker': 'Ahmed Furat',
  'co-worker-age': 27,
  'co-worker-career': 'software engineer',
  'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
  'co-worker-birthDate': '11/07/1993',
  'sub-data': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'sub-sub-data': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'sub-sub': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'payload': {
    'name': 'Karrar Mohammed',
    'age': 27,
    'career': 'software engineer',
    'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
    'birthDate': '17/05/1993',
    'co-worker': 'Ahmed Furat',
    'co-worker-age': 27,
    'co-worker-career': 'software engineer',
    'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
    'co-worker-birthDate': '11/07/1993',
  },
  'hobbies':[
    for(var i = 0; i < 1000;i++)
      {
        'name': 'Karrar Mohammed',
        'age': 27,
        'career': 'software engineer',
        'projects': ['Locator', 'yalla ensafer', 'taxi', 'malzama'],
        'birthDate': '17/05/1993',
        'co-worker': 'Ahmed Furat',
        'co-worker-age': 27,
        'co-worker-career': 'software engineer',
        'co-worker-projects': ['yalla ensafer', 'taxi', 'malzama'],
        'co-worker-birthDate': '11/07/1993',
      }
  ]
};
