import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class CollegeUploadedPDF implements BaseUploadingModel {
  @override
  String key;

  String title;
  String description;
  String post_date;
  String src;
  String path;
  int size;
  String topic;

  // --------
  String college;
  String university;
  int semester;
  int stage;
  String section;

  String _material_collection;
  String _material_type;
  List<String> _comments;
  String _comments_collection;
  Map<String, dynamic> _author;

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
    Map<String, dynamic> author,
    this.topic,

    //
    String material_collection,
    String material_type,
    List<String> comments,
    String comments_collection,
  })  : _comments = comments,
        _author = author,
        _material_collection = material_collection,
        _material_type = material_type;

  @override
  CollegeUploadedPDF.fromJSON(Map map)
      : this.key = map['_id'],
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
        this._author = map['author'],
        this.topic = map['topic'],
        this.size = map['size'],

        //
        this._material_collection = map['material_collection'],
        this._material_type = map['material_type'],
        this._comments_collection = map['comments_collection'],
        this._comments = map['comments'].map<String>((item) => item.toString()).toList();

  @override
  Map<String, dynamic> toJSON() => <String, dynamic>{
        '_id': this.key,
        'title': this.title,
        'description': this.description,
        'post_date': this.post_date,
        'src': this.src,
        'path': this.path,

        // ********************
        'university': this.university,
        'college': this.college,
        'stage': this.stage.toString(),
        'section': this.section,
        'semester': this.semester,

        //**************
        'author': this.author,
        'topic': this.topic,
        'size': this.size,

        //********
        'material_collection': this.material_collection,
        'material_type': this.material_type,
        'comments_collection': this.comments_collection,
        'comments': this.comments,
      };

  Map<String, dynamic> getCommentRelatedData() {
    return {
      'material_id': key,
      'material_collection': material_collection,
      'material_type': material_type,
      'comments_collection': comments_collection,
      'author_notifications_repo': author['notifications_repo'],
      'author_one_signal_id': author['one_signal_id'],
      'author_id': author['_id'],
    };
  }

  @override
  Map<String, dynamic> get author => _author;

  @override
  List<String> get comments => _comments;

  @override
  String get comments_collection => _comments_collection;

  @override
  String get material_collection => _material_collection;

  @override
  String get material_type => _material_type;

  @override
  String get material_id => key;
}
