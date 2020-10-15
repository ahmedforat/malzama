import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';

class QuizDraftEntity {
  String id;
  QuizCredentials credentials;
  List<QuizEntity> quizItems;
  int storeIndex;

  QuizDraftEntity({
    this.id,
    this.credentials,
    this.quizItems,
    this.storeIndex,
  });

  QuizDraftEntity.fromJSON(Map<String, dynamic> json)
      : this.id = json['id'],
        this.credentials = QuizCredentials.fromJSON(json['credentials']),
        this.quizItems = json['quizItems'].map<QuizEntity>((item) => item as QuizEntity).toList(),
        this.storeIndex = json['index'];

  Map<String, dynamic> toJSON() => {
        'id': this.id,
        'credentials': this.credentials.toJSON(),
        'quizItems': this.quizItems.map((e) => e.toJSON()).toList(),
        'index': this.storeIndex,
      };

  QuizDraftEntity get clone => new QuizDraftEntity(credentials: this.credentials, quizItems: this.quizItems, storeIndex: this.storeIndex);
}

class QuizCredentials {
  String title;
  String description;
  String topic;
  String stage;
  String semester;
  String college;
  String university;
  String schoolSection;
  String section;

  QuizCredentials({
    this.title,
    this.description,
    this.topic,
    this.stage,
    this.semester,
    this.college,
    this.university,
    this.schoolSection,
    this.section,
  });

  QuizCredentials.fromJSON(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        topic = json['topic'],
        stage = json['stage'].toString(),
        semester = json['semester'].toString(),
        college = json['college'],
        university = json['university'],
        schoolSection = json['school_section'],
        section = json['section'];

  Map<String, dynamic> toJSON() => {
        'title': this.title,
        'description': this.description,
        'topic': this.topic,
        'stage': this.stage,
        'semester': this.semester,
        'college': this.college,
        'university': this.university,
        'school_section': this.schoolSection,
        'section': this.section,
      };
}
