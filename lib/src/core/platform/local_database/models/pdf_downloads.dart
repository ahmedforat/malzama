class DownloadedSchoolPDF {
  String title;
  String description;
  DateTime createdAt;
  String path;
  String author;
  int stage;
  String school_section;

  DownloadedSchoolPDF(
      {this.title,
      this.description,
      this.createdAt,
      this.path,
      this.author,
      this.stage,
      this.school_section});

  factory DownloadedSchoolPDF.fromMap(Map<String, dynamic> map) {
    return new DownloadedSchoolPDF(
      title: map['title'],
      description: map['description'],
      createdAt: map['createdAt'],
      path: map['path'],
      author: map['author'],
      stage: map['stage'],
      school_section: map['school_section'],
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
        'title': this.title,
        'description': this.description,
        'createdAt': this.createdAt,
        'path': this.path,
        'author': this.author,
        'stage': this.stage,
        'school_section': this.school_section
      };
}
