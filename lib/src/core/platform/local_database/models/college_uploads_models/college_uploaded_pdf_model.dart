import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class CollegeUploadedPDF implements BaseUploadingModel{
  @override
  String key;

  String title;
  String description;
  String post_date;
  String src;
  String path;
  int size;

  // --------
  String college;
  String university;
  int semester;
  int stage;
  String section;

  String author;
  String topic;

  CollegeUploadedPDF({
    this.key,
    this.title,
    this.description,
    this.post_date,
    this.src,
    this.path,

    // ************************
    this.university,
    this.college,
    this.stage,
    this.section,
    this.semester,

    //***********
    this.size,
    this.author,
    this.topic
  });

  @override
  CollegeUploadedPDF.fromJSON(Map map):
        this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.src = map['src'],
        this.path = map['path'],

  //********************
        this.university = map['university'],
        this.college = map['college'],
        this.stage = int.parse(map['stage'].toString()),
        this.section = map['section'],
        this.semester = map['semester'],

  //******************
        this.author = map['author'],
        this.topic = map['topic'],
        this.size = map['size'];


  @override
  Map<String,dynamic> toJSON() => <String,dynamic>{
    '_id': this.key,
    'title': this.title,
    'description': this.description,
    'post_date': this.post_date,
    'src': this.src,
    'path': this.path,

    // ********************
    'university':this.university,
    'college':this.college,
    'stage': this.stage.toString(),
    'section': this.section,
    'semester':this.semester,


    //**************
    'author': this.author,
    'topic':this.topic,
    'size':this.size
  };

}
