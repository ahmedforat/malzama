import 'package:malzama/src/core/platform/local_database/models/base_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/college_uploads_models/college_uploaded_video_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_pdf_model.dart';
import 'package:malzama/src/core/platform/local_database/models/school_uploads_models/school_uploaded_video_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:sembast/sembast.dart';

import '../app_database.dart';

class TeacherAccessObject{
  static const String MY_UPLOADED_PDFS = 'my_pdfs_uploads';
  static const String MY_UPLOADED_VIDEOS = 'my_video_uploads';

  final myPDFUploads = intMapStoreFactory.store(MY_UPLOADED_PDFS);
  final myVideoUploads = intMapStoreFactory.store(MY_UPLOADED_VIDEOS);

  Future<Database> get database async => await LocalDatabase.getInstance().database;

  // for lectures or PDFS

  Future insert(BaseUploadingModel pdf) async {
    await myPDFUploads.add(await this.database, pdf.toJSON());
  }

  Future update<PDF_TYPE extends BaseUploadingModel>(PDF_TYPE pdf) async {
    await myPDFUploads.update(await this.database, pdf.toJSON(), finder: new Finder(filter: Filter.byKey(pdf.key)));
  }

  Future delete<PDF_TYPE extends BaseUploadingModel>(PDF_TYPE pdf) async {
    await myPDFUploads.delete(await this.database, finder: Finder(filter: Filter.byKey(pdf.key)));
  }

  Future<List<BaseUploadingModel>> fetchAllPDFS<PDF_TYPE extends BaseUploadingModel>() async {
    var data = await myPDFUploads.find(await this.database);

    var pdfs = data.map((record) {
      if (PDF_TYPE == CollegeUploadedPDF) {
        return new CollegeUploadedPDF.fromJSON(record.value);
      } else {
        return new SchoolUploadedPDF.fromJSON(record.value);
      }
    }).toList();

    return pdfs;


  }

  // for videos

  Future insertVideo(BaseUploadingModel video) async {
    print('******************* just before saving in the database');
    print(video.toJSON());
    print('********************************************************');
    await myVideoUploads.add(await this.database, video.toJSON());
  }

  Future updateVideo<VIDEO_TYPE extends BaseUploadingModel>(VIDEO_TYPE video) async {
    await myVideoUploads.update(await this.database, video.toJSON(), finder: new Finder(filter: Filter.byKey(video.key)));
  }

  Future deleteVideo<VIDEO_TYPE extends BaseUploadingModel>(VIDEO_TYPE video) async {
    await myVideoUploads.delete(await this.database, finder: Finder(filter: Filter.byKey(video.key)));
  }

  Future<List<BaseUploadingModel>> fetchAllVideos<VIDEO_TYPE extends BaseUploadingModel>() async {
    var data = await myVideoUploads.find(await this.database);

    var videos = data.map((record) {
      if(VIDEO_TYPE == CollegeUploadedVideo){
        return CollegeUploadedVideo.fromJSON(record.value);
      }else{
        return SchoolUploadedVideo.fromJSON(record.value);
      }
    }).toList();


    return videos;
  }
}
