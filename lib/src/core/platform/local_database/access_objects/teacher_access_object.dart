import 'package:sembast/sembast.dart';

import '../app_database.dart';
import '../models/uploaded_pdf_and_video_model.dart';


class TeacherAccessObject {
  
  static const String MY_UPLOADED_PDFS = 'my_pdfs_uploads';
  static const String MY_UPLOADED_VIDEOS = 'my_video_uploads';

  final myPDFUploads = intMapStoreFactory.store(MY_UPLOADED_PDFS);
  final myVideoUploads = intMapStoreFactory.store(MY_UPLOADED_VIDEOS);

  Future<Database> get database async =>
      await LocalDatabase.getInstance().database;


  // for lectures or PDFS
  
  Future insert(UploadedPDF pdf) async {
    await myPDFUploads.add(await this.database, pdf.toJSON());
  }

  Future update(UploadedPDF pdf) async {
    await myPDFUploads.update(await this.database, pdf.toJSON(),
        finder: new Finder(filter: Filter.byKey(pdf.key)));
  }

  Future delete(UploadedPDF pdf) async {
    await myPDFUploads.delete(await this.database,
        finder: Finder(filter: Filter.byKey(pdf.key)));
  }

  Future<List<UploadedPDF>> fetchAllPDFS()async{
    var data = await myPDFUploads.find(await this.database);
    
    List<UploadedPDF> pdfs = data.map((record){
      UploadedPDF uploadedSchoolPDF = UploadedPDF.fromJSON(record.value);
      return uploadedSchoolPDF;
    }).toList();

    return pdfs;
  }


  // for videos

   Future insertVideo(UploadedVideo video) async {
    print('******************* just before saving in the database');
    print(video.toJSON());
    print('********************************************************');
    await myVideoUploads.add(await this.database, video.toJSON());
  }

  Future updateVideo(UploadedVideo video) async {
    await myVideoUploads.update(await this.database, video.toJSON(),
        finder: new Finder(filter: Filter.byKey(video.key)));
  }

  Future deleteVideo(UploadedVideo video) async {
    await myVideoUploads.delete(await this.database,
        finder: Finder(filter: Filter.byKey(video.key)));
  }

  Future<List<UploadedVideo>> fetchAllVideos()async{
    var data = await myVideoUploads.find(await this.database);
    
    List<UploadedVideo> videos = data.map((record){
      UploadedVideo uploadedSchoolVideo = UploadedVideo.fromJSON(record.value);
      return uploadedSchoolVideo;
    }).toList();

    return videos;
  }
}
