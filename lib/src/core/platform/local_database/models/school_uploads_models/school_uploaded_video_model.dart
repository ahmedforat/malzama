import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class SchoolUploadedVideo implements BaseUploadingModel {
  @override
  String key;

  String title;
  String description;
  String post_date;
  String videoId;
  String path;

  // --------
  int stage;
  String school_section;
  String author;
  String topic;

  SchoolUploadedVideo(
      {this.key,
        this.title,
        this.description,
        this.post_date,
        this.videoId,
        this.path,
        this.stage,
        this.school_section,
        this.topic,
        this.author});

  @override
  SchoolUploadedVideo.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.videoId = map['videoId'],
        this.path = map['path'],
        this.stage = int.parse(map['stage'].toString()),
        this.school_section = map['school_section'],
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
    'stage': this.stage.toString(),
    'school_section': this.school_section,
    'author': this.author,
    'topic':this.topic
  };
}
