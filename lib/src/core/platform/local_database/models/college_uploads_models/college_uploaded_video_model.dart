import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class CollegeUploadedVideo implements BaseUploadingModel {
  @override
  String key;

  String title;
  String description;
  String post_date;
  String videoId;
  String topic;

  // --------
  String university;
  String college;
  int stage;
  String section;
  int semester;

  Map<String, dynamic> _author;
  String _material_collection;
  String _material_type;
  List<String> _comments;
  String _comments_collection;

  CollegeUploadedVideo({
    this.key,
    this.title,
    this.description,
    this.post_date,
    this.videoId,
    this.stage,
    this.section,
    this.topic,
    Map<String, dynamic> author,
    this.college,
    this.university,
    this.semester,
    String material_collection,
    String material_type,
    List<String> comments,
    String comments_collection,
  })  : _author = author,
        _comments_collection = comments_collection,
        _comments = comments,
        _material_collection = material_collection,
        _material_type = material_type;

  @override
  CollegeUploadedVideo.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.videoId = map['videoId'],
        this.university = map['university'],
        this.college = map['college'],
        this.stage = int.parse(map['stage'].toString()),
        this.section = map['section'],
        this.semester = map['semester'],
        this._author = map['author'],
        this.topic = map['topic'],
        this._material_collection = map['material_collection'],
        this._material_type = map['material_type'],
        this._comments_collection = map['comments_collection'],
        this._comments = map['comments'].map<String>((item) => item.toString()).toList();

  @override
  Map<String, dynamic> toJSON() => {
        '_id': this.key,
        'title': this.title,
        'description': this.description,
        'post_date': this.post_date,
        'videoId': this.videoId,

        // ********************
        'university': this.university,
        'college': this.college,
        'stage': this.stage.toString(),
        'section': this.section,
        'semester': this.semester,

        //**********
        'author': this.author,
        'topic': this.topic,

        //******
        'material_collection': this.material_collection,
        'material_type': this.material_type,
        'comments_collection': this.comments_collection,
        'comments': this.comments,
      };

//  'material_collection': materialInfo['material_collection'],
//  'material_id': materialID,
//  'comments_collection': commentsCollection,
//  'material_type': materialType,
//  'author_notifications_repo':'',
//  'author_id':''

  @override
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
