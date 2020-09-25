import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class SchoolUploadedVideo implements BaseUploadingModel {
  @override
  String key;

  String title;
  String description;
  String post_date;
  String videoId;

  // --------
  int stage;
  String school_section;
  Map<String, dynamic> _author;
  String topic;

  String _material_collection;
  String _material_type;
  List<String> _comments;
  String _comments_collection;

  SchoolUploadedVideo({
    this.key,
    this.title,
    this.description,
    this.post_date,
    this.videoId,
    this.stage,
    this.school_section,
    this.topic,
    Map<String, dynamic> author,
    String material_collection,
    String material_type,
    List<String> comments,
    String comments_collection,
  }): _comments = comments,
        _author = author,
        _material_collection = material_collection,
        _material_type = material_type;

  @override
  SchoolUploadedVideo.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.videoId = map['videoId'],
        this.stage = int.parse(map['stage'].toString()),
        this.school_section = map['school_section'],
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
        'stage': this.stage.toString(),
        'school_section': this.school_section,
        'author': this.author,
        'topic': this.topic,
        'material_collection': this.material_collection,
        'material_type': this.material_type,
        'comments_collection': this.comments_collection,
        'comments': this.comments,
      };

  Map<String,dynamic> getCommentRelatedData(){
    return {
      'material_id':key,
      'material_collection':material_collection,
      'material_type':material_type,
      'comments_collection':comments_collection,
      'author_notifications_repo':author['notifications_repo'],
      'author_one_signal_id':author['one_signal_id'],
      'author_id':author['_id'],
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
