import 'package:flutter/cupertino.dart';

class QuizEntity {
  String question;
  List<String> options;
  List<int> answers;
  String explanation;
  bool inReviewMode = false;

  QuizEntity({String question,  List<String>options , List<int> answers , String explanation}){
    this.question = question;
    this.options = options?? new List(4);
    this.answers = answers ?? new List();
    this.explanation = explanation;
  }


  bool get isEmpty => this.question == null || this.question.isEmpty || this.options.length < 4;
  bool get hasAnswers => this.answers.length > 0;

  QuizEntity.fromJSON(Map map)
      :this.question = map['question'],
        this.options = List<String>.from(map['options']),
        this.answers = List<int>.from(map['answers']),
        this.explanation = map['explanation'];

  Map<String, dynamic> toJSON() =>
      {
        'question': this.question,
        'options': this.options,
        'answers': this.answers,
        'explanation': this.explanation
      };
}