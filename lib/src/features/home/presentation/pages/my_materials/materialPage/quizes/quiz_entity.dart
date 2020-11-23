

class QuizEntity {
  String id;
  String question;
  List<String> options;
  List<int> answers;
  String explain;
  bool inReviewMode = false;

  QuizEntity({this.id, String question, List<String> options, List<int> answers, String explanation}) {
    this.question = question;
    this.options = options ?? new List(4);
    this.answers = answers ?? new List();
    this.explain = explanation;
  }

  bool get isEmpty => this.question == null || this.question.isEmpty || this.options.length < 4;

  bool get hasAnswers => this.answers.length > 0;

  QuizEntity.fromJSON(Map map)
      : this.id = map['_id'],
        this.question = map['question'],
        this.options = List<String>.from(map['options']),
        this.answers = List<int>.from(map['answers']),
        this.explain = map['explain'],
        this.inReviewMode = map['inReviewMode'];

  Map<String, dynamic> toJSON() => {
        '_id': this.id,
        'question': this.question,
        'options': this.options,
        'answers': this.answers,
        'explain': this.explain,
        'inReviewMode': this.inReviewMode,
      };


}
