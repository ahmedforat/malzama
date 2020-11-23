import '../../../../../models/material_author.dart';
import 'quiz_draft_model.dart';
import 'quiz_entity.dart';

class QuizCollection extends Quiz {
  String postDate;
  int questionsCount;
  MaterialAuthor author;

  QuizCollection({
    String id,
    this.postDate,
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
    this.questionsCount = int.parse(json['questionsCount'].toString());
    this.author = new MaterialAuthor.fromJSON(json['author']);
  }

  Map<String, dynamic> toJSON() => {
        '_id': this.id,
        'post_date': this.postDate,
        'questionsCount': this.questionsCount,
        'author': this.author.toJSON(),
        'questions': this.quizItems?.map((e) => e?.toJSON())?.toList() ?? [],
      }..addAll(this.credentials.toJSON());
}
