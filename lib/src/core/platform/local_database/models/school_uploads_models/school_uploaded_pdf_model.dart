import 'package:malzama/src/core/platform/local_database/models/base_model.dart';

class SchoolUploadedPDF implements BaseUploadingModel {
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
  int stage;
  String school_section;
  Map<String, dynamic> _author;

  // **
  String _material_collection;
  String _material_type;
  List<String> _comments;
  String _comments_collection;

  SchoolUploadedPDF({
    this.key,
    this.title,
    this.description,
    this.post_date,
    this.src,
    this.path,
    this.stage,
    this.school_section,
    Map<String, dynamic> author,
    this.size,
    String material_collection,
    String material_type,
    this.topic,
    List<String> comments,
    String comments_collection,
  })  : _comments = comments,
        _author = author,
        _material_collection = material_collection,
        _material_type = material_type;

  @override
  SchoolUploadedPDF.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.src = map['src'],
        this.path = map['path'],
        this.stage = int.parse(map['stage'].toString()),
        this.school_section = map['school_section'],
        this._author = map['author'],
        this.size = int.parse(map['size']),
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
        'src': this.src,
        'path': this.path,
        'stage': this.stage.toString(),
        'school_section': this.school_section,
        'author': this.author,
        'size': this.size.toString(),
        'material_type': this.material_type,
        'material_collection': this.material_collection,
        'topic': this.topic,
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
