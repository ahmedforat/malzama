import '../../../../../models/material_author.dart';
import 'quiz_draft_model.dart';
import 'quiz_entity.dart';

class QuizCollection extends Quiz {
  String postDate;
  String lastUpdate;
  int questionsCount;
  MaterialAuthor author;

  QuizCollection({
    String id,
    this.postDate,
    this.lastUpdate,
    this.questionsCount,
    this.author,
    QuizCredentials credentials,
    List<QuizEntity> quizItems,
  }) : super(
          id: id,
          credentials: credentials,
          quizItems: quizItems,
        );

  QuizCollection.fromJSON(Map<String, dynamic> json) : super.fromJSON(json) {
    this.postDate = json['post_date'];
    this.lastUpdate = json['last_update'];
    this.questionsCount = int.parse(json['questionsCount'].toString());
    this.author = new MaterialAuthor.fromJSON(json['author']);
  }

  Map<String, dynamic> toJSON() => {
        '_id': id,
        'post_date': postDate,
        'last_update': lastUpdate,
        'questionsCount': questionsCount,
        'author': author.toJSON(),
        'questions': quizItems?.map((e) => e?.toJSON())?.toList() ?? [],
        ...credentials.toJSON(),
      };
}
