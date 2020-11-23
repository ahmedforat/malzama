import 'package:malzama/src/core/general_widgets/helper_functions.dart';
import 'package:malzama/src/core/platform/local_database/local_caches/cached_user_info.dart';

import 'package:malzama/src/features/home/models/materials/college_material.dart';
import 'package:malzama/src/features/home/models/materials/school_material.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';
import 'package:sembast/sembast.dart';

import '../app_database.dart';

class TeacherAccessObject {
  static const String MY_UPLOADED_PDFS = 'my_pdfs_uploads';
  static const String MY_UPLOADED_VIDEOS = 'my_video_uploads';

  final myPDFUploads = intMapStoreFactory.store(MY_UPLOADED_PDFS);
  final myVideoUploads = intMapStoreFactory.store(MY_UPLOADED_VIDEOS);

  Future<Database> get database async => await LocalDatabase.getInstance().database;

  // for lectures or PDFS

  Future insert(StudyMaterial pdf) async {
    await myPDFUploads.add(await this.database, pdf.toJSON());
  }

  Future update(StudyMaterial pdf) async {
    await myPDFUploads.update(await this.database, pdf.toJSON(), finder: new Finder(filter: Filter.matches('_id', pdf.id)));
  }

  Future delete(StudyMaterial pdf) async {
    await myPDFUploads.delete(await this.database, finder: Finder(filter: Filter.matches('_id', pdf.id)));
  }

  Future<List<StudyMaterial>> fetchAllPDFS() async {
    var data = await myPDFUploads.find(await this.database);
    var accountType = await UserCachedInfo().getRecord('account_type');
    var pdfs = data.map((record) {
      bool isAcademic = HelperFucntions.isAcademic(accountType);
      if (isAcademic) {
        return new CollegeMaterial.fromJSON(record.value);
      } else {
        return new SchoolMaterial.fromJSON(record.value);
      }
    }).toList();

    return pdfs;
  }

  // for videos

  Future insertVideo(StudyMaterial video) async {
    print('******************* just before saving in the database');
    print(video.toJSON());
    print('********************************************************');
    await myVideoUploads.add(await this.database, video.toJSON());
  }

  Future updateVideo(StudyMaterial video) async {
    await myVideoUploads.update(await this.database, video.toJSON(), finder: new Finder(filter: Filter.matches('_id', video.id)));
  }

  Future deleteVideo(StudyMaterial video) async {
    await myVideoUploads.delete(await this.database, finder: Finder(filter: Filter.matches('_id', video.id)));
  }

  Future<List<StudyMaterial>> fetchAllVideos() async {
    var data = await myVideoUploads.find(await this.database);
    var accountType = await UserCachedInfo().getRecord('account_type');
    bool isAcademic = HelperFucntions.isAcademic(accountType);
    var videos = data.map((record) {
      if (isAcademic) {
        return CollegeMaterial.fromJSON(record.value);
      } else {
        return SchoolMaterial.fromJSON(record.value);
      }
    }).toList();

    return videos;
  }
}
