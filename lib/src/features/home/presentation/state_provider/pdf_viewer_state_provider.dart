import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:malzama/src/core/api/routes.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/platform/services/caching_services.dart';
import '../../../../core/platform/services/dialog_services/dialog_service.dart';
import '../../../../core/platform/services/dialog_services/service_locator.dart';

enum PDFSource { URL, LOCAL_STORAGE }

class PdfViewerState with ChangeNotifier {
  String _pdfPath;

  String get pdfPath => _pdfPath;

  List<String> _pdfDownloads;

  List<String> get pdfDownloads => _pdfDownloads;

  int _progress = 0;

  int get progress => _progress;

  DialogService serviceLocator;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _hasError = false;

  bool get hasError => _hasError;

  String _errorMessage;

  String get errorMessage => _errorMessage;

  PdfViewerState() {
    serviceLocator = locator.get<DialogService>();
    if (serviceLocator.pdfSource == PDFSource.URL) {
      _loadPDFromUrl();
    }
  }

  Future<void> anotherLoadMethod() async {
    _isLoading = true;
    String _url = Api.getSuitableUrl(
            accountType: serviceLocator
                .profilePageState.userData.commonFields.account_type) +
        '/send-me-lecture';
    String token = await CachingServices.getField(key: 'token');
    Map<String, String> _headers = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'authorization': token
    };
    var data = await http.post(Uri.encodeFull(_url),
        body: jsonEncode({'lecture_path': serviceLocator.pdfUrl}),
        headers: _headers);
    Directory tempDir = await getTemporaryDirectory();
    File file = new File(tempDir.path + '/temp_read.pdf');
    print('we are here');
    File resultFile = await file.writeAsBytes(data.bodyBytes);
    print('we are here and we are lucky if we get printed');
    updatePdfPath(resultFile.path);
    _isLoading = false;
    notifyListeners();
    print('*************************************');
    print(pdfPath);
    print('*************************************');
  }

  Future<void> _loadPDFromUrl() async {
    print('here we go');
    _isLoading = true;
    print('this is the value of progress  $progress');
    notifyListeners();

    List<int> bytes = [];
    String token = await CachingServices.getField(key: 'token');
    Map<String, String> _headers = {
      // "content-type": "application/x-www-form-urlencoded",
      "authorization": token
    };

    String _url = Api.getSuitableUrl(
            accountType: serviceLocator
                .profilePageState.userData.commonFields.account_type) +
        '/send-me-lecture';
//    http.MultipartRequest multipartRequest = http.MultipartRequest('POST',Uri.parse(_url));
//    multipartRequest.headers.addAll(_headers);
//    multipartRequest.fields['lecture_path'] = serviceLocator.pdfUrl;
//    http.Request request =  http.Request('POST',Uri.parse(_url));
//    request.bodyFields.addAll({"lecture_path":serviceLocator.pdfUrl});
//
//    request.headers.addAll(_headers);
//    request.headers.add('content-type', 'application/json');
//    request.headers.add('authorization', await CachingServices.getField(key: 'token'));
//    request.add(utf8.encode(json.encode({'lecture_path':serviceLocator.pdfUrl})));

    Dio dio = new Dio();

//    var response = await dio.download(_url, file.path,
//        onReceiveProgress: (rec, total) {
//      _progress = (rec / total * 100).floor();
//      if (progress >= 100) {
//        _isLoading = false;
//        updatePdfPath(file.path);
//      }
//      notifyListeners();
//    },
//        options: Options(
//            headers: _headers,
//            method: 'POST',
//            extra: {'lecture_path': serviceLocator.pdfUrl}));


    Response<ResponseBody> response = await dio.post(
      _url,
      data: json.encode({'lecture_path': serviceLocator.pdfUrl}),
      options: Options(
        method: 'POST',
        headers: _headers,
        responseType: ResponseType.stream,
        contentType: 'application/json',
        receiveTimeout: 500,
      ),

//      onReceiveProgress: (inc, total) {
//        _progress = int.parse((inc / total * 100).floor().toString());
//        if (_progress >= 100) {
//          _isLoading = false;
//          updatePdfPath(file.path);
//        }
//        notifyListeners();
//      },
    );
    Directory tempDir = await getTemporaryDirectory();
    File file = new File(tempDir.path + '/temp_read.pdf');
    String rawData = '';
    response.data.stream.listen((chunks){
      bytes.addAll(chunks);
      //rawData += chunks.toString();
      _progress = (bytes.length / serviceLocator.pdfSize * 100).floor();
      notifyListeners();
    },onDone: ()async{
      _isLoading = false;
       file.writeAsBytesSync(bytes);

     updatePdfPath(file.path);
    });

//    try{
//      response.data.stream.listen(
//        (chunks) {
//          print(chunks.length);
//          bytes.addAll(chunks);
//          _progress = int.parse(((bytes.length / serviceLocator.pdfSize) * 100)
//              .toString()
//              .substring(0, 2));
//          print(_progress);
//          notifyListeners();
//        },
//        cancelOnError: true,
//        onDone: () async {
//          _progress = 0;
//          _isLoading = false;
//          Directory tempDir = await getApplicationDocumentsDirectory();
//          File file = new File(tempDir.path + '/temp_read.pdf');
//          var written = await file.writeAsString(bytes.toString());
//          updatePdfPath(written.path);
//        },
//      );
//    }catch(err){
//      print(err);
//    }

//    var response = await http.Client().send(request);
//    var response = await multipartRequest.send();
//    response.stream.listen((List<int> data) {
//      bytes.addAll(data);
//      final downloadedBytes = bytes.length;
//      //_progress = int.parse(((downloadedBytes / serviceLocator.pdfSize )* 100).toString().substring(0,2));
//      notifyListeners();
//    }, onDone: () async {
//      print('on done has been reached');
//      print(bytes.length);
//      _progress = 0;
//      _isLoading = false;
//
//      try {
//        Directory tempDir = await getApplicationDocumentsDirectory();
//        File file = new File(tempDir.path + '/temp_read.pdf');
//        print('we are here');
//        File resultFile = await file.writeAsBytes(bytes);
//        print('we are here and we are lucky if we get printed');
//        updatePdfPath(resultFile.path);
//        print('*************************************');
//        print(pdfPath);
//        print('*************************************');
//      } catch (err) {
//        print(err.toString());
//      }
//      print('this must be printed the first one');
//      notifyListeners();
//    }, onError: (err) {
//      _isLoading = false;
//      _hasError = true;
//      _errorMessage = err.toString();
//      notifyListeners();
//      // here you close the loading dialoge
//      // show a failure message to the user
//      // and then close the dialgo via the service locator
//    }, cancelOnError: true);
  }

  Future savePDFtoDownloads() async {
    Directory tempDir = await getTemporaryDirectory();
    File file = new File(tempDir.path + '/temp_read.pdf');
    Directory directory = await getApplicationDocumentsDirectory();
    Directory myPdfList = new Directory(directory.path + '/my_pdf_downloads');
  }

  // Future<void> _loadAllPDFdownloads()async{
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   Directory myPdfList = new Directory(directory.path + '/my_pdf_downloads');
  //   List<File> myPdfDownloads =  myPdfList.listSync();
  //   List<String> downloadsPaths = myPdfDownloads.map((pdf) => pdf.path);
  //   updatePdfDownloads(downloadsPaths);
  // }

  void updatePdfPath(String update) {
    if (update != null) {
      _pdfPath = update;
      notifyListeners();
    }
  }

  void updatePdfDownloads(List<String> update) {
    if (update != null) {
      _pdfDownloads = update;
      notifyListeners();
    }
  }

  void setAllFieldToNull() {
    _pdfPath = null;
  }
}
