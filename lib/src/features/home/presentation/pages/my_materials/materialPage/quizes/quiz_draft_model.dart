import '../../../../../../../core/platform/services/dialog_services/service_locator.dart';
import '../../../../state_provider/user_info_provider.dart';
import 'quiz_entity.dart';

class Quiz {
  String id;
  QuizCredentials credentials;
  List<QuizEntity> quizItems;
  bool isSaved;

  Quiz({
    this.id,
    this.credentials,
    this.quizItems,
  }) : isSaved = locator<UserInfoStateProvider>().userData.savedQuizes.contains(id);

  Quiz.fromJSON(Map<String, dynamic> json)
      : this.id = json['_id'],
        credentials = new QuizCredentials.fromJSON(json),
        quizItems = json['questions'].map<QuizEntity>((item) => new QuizEntity.fromJSON(item)).toList(),
        isSaved = locator<UserInfoStateProvider>().userData.savedQuizes.contains(json['_id']);

  Map<String, dynamic> toJSON() => {
        '_id': id,
        'questions': quizItems.map((e) => e.toJSON()).toList(),
      }..addAll(this.credentials.toJSON());
}

class QuizDraftEntity extends Quiz {
  int storeIndex;

  QuizDraftEntity({
    String id,
    QuizCredentials credentials,
    List<QuizEntity> quizItems,
    this.storeIndex,
  }) : super(
          credentials: credentials,
          quizItems: quizItems,
          id: id,
        );

  QuizDraftEntity.fromJSON(Map<String, dynamic> json)
      : this.storeIndex = json['index'],
        super.fromJSON(json);

  Map<String, dynamic> toJSON() => {
        '_id': this.id,
        'questions': this.quizItems.map((e) => e.toJSON()).toList(),
        'index': this.storeIndex,
      }..addAll(this.credentials.toJSON());

  QuizDraftEntity get clone => new QuizDraftEntity(
        credentials: this.credentials,
        quizItems: this.quizItems,
        storeIndex: this.storeIndex,
      );
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
  String school;
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
    this.school,
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
        section = json['section'],
        school = json['school'];

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
        'school': this.school,
      };
}
