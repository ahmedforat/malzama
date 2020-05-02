class UploadedPDF {
  String key;
  String title;
  String description;
  String post_date;
  String src;
  String path;
  int size;

  // --------
  int stage;
  String school_section;
  String author;

  UploadedPDF(
      {this.key,
      this.title,
      this.description,
      this.post_date,
      this.src,
      this.path,
      this.stage,
      this.school_section,
      this.author,
      this.size});

  UploadedPDF.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.src = map['src'],
        this.path = map['path'],
        this.stage = int.parse(map['stage'].toString()),
        this.school_section = map['school_section'],
        this.author = map['author'],
        this.size = int.parse(map['size']);

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
        'size': this.size.toString()
      };
}

class UploadedVideo {
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

  UploadedVideo(
      {this.key,
      this.title,
      this.description,
      this.post_date,
      this.videoId,
      this.path,
      this.stage,
      this.school_section,
      this.author});

  UploadedVideo.fromJSON(Map map)
      : this.key = map['_id'],
        this.title = map['title'],
        this.description = map['description'],
        this.post_date = map['post_date'],
        this.videoId = map['videoId'],
        this.path = map['path'],
        this.stage = int.parse(map['stage'].toString()),
        this.school_section = map['school_section'],
        this.author = map['author'];

  Map<String, dynamic> toJSON() => {
        '_id': this.key,
        'title': this.title,
        'description': this.description,
        'post_date': this.post_date,
        'videoId': this.videoId,
        'path': this.path,
        'stage': this.stage.toString(),
        'school_section': this.school_section,
        'author': this.author
      };
}
