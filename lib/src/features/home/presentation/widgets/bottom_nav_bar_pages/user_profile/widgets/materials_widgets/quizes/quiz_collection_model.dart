import 'package:malzama/src/features/home/models/material_author.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_draft_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_entity.dart';
import 'package:malzama/src/features/home/presentation/widgets/bottom_nav_bar_pages/user_profile/widgets/materials_widgets/quizes/quiz_player/quiz_player_state_provider.dart';

class QuizCollection {
  String id;
  String postDate;
  int questionsCount;
  QuizCredentials credentials;
  List<PlayerQuizEntity> quizItems;
  MaterialAuthor author;

  QuizCollection({
    this.id,
    this.postDate,
    this.questionsCount,
    this.author,
    this.credentials,
    this.quizItems,
  });

  QuizCollection.fromJSON(Map<String, dynamic> json)
      : this.id = json['_id'],
        this.postDate = json['post_date'],
        this.questionsCount = int.parse(json['questionsCount'].toString()),
        this.author = new MaterialAuthor.fromJSON(json['author']),
        this.credentials = new QuizCredentials.fromJSON(json),
        this.quizItems = json['questions'].map<PlayerQuizEntity>((item) => new PlayerQuizEntity.fromJSON(item)).toList();

  Map<String, dynamic> toJSON() => {
        '_id': this.id,
        'post_date': this.postDate,
        'questionsCount': this.questionsCount,
        'author': this.author.toJSON(),
        'credentials': this.credentials.toJSON(),
        'quizItems': this.quizItems?.map((e) => e?.toJSON())?.toList() ?? [],
      };

}
