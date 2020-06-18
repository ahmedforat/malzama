
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class CollegeUploadedVideo implements BaseUploadingModel {
  @override
  String key;

  String title;
  String description;
  String post_date;
  String videoId;
  String path;

  // --------
  String university;
  String college;
  int stage;
  String section;
  int semester;
  String author;
  String topic;

  CollegeUploadedVideo(
      {this.key,
        this.title,
        this.description,
        this.post_date,
        this.videoId,
        this.path,
        this.stage,
        this.section,
        this.topic,
        this.author,
        this.college,
        this.university,
        this.semester});

  @override
  CollegeUploadedVideo.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.videoId = map['videoId'],
        this.path = map['path'],


        this.university = map['university'],
        this.college = map['college'],
        this.stage = int.parse(map['stage'].toString()),
        this.section = map['section'],
        this.semester = map['semester'],

        this.author = map['author'],
        this.topic = map['topic'];


  @override
  Map<String, dynamic> toJSON() => {

    '_id': this.key,
    'title': this.title,
    'description': this.description,
    'post_date': this.post_date,
    'videoId': this.videoId,
    'path': this.path,

    // ********************
    'university':this.university,
    'college':this.college,
    'stage': this.stage.toString(),
    'section': this.section,
    'semester':this.semester,

    //**********
    'author': this.author,
    'topic':this.topic,
  };
}
