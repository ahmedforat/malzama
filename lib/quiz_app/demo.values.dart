
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'category.dart';
import 'question.dart';

const Map<int,dynamic> demoAnswers = {
  0:"Multi Pass",
  1:1,
  2:"Motherboard",
  3:"Cascading Style Sheet",
  4:"Marshmallow",
  5:"140",
  6:"Python",
  7:"True",
  8:"Jakarta"
};

final List<Category> categories = [
  Category(9,"Part1", icon: FontAwesomeIcons.globeAsia),
  Category(10,"Part2", icon: FontAwesomeIcons.bookOpen),
  Category(11,"Part3", icon: FontAwesomeIcons.video),
  Category(12,"part4", icon: FontAwesomeIcons.music),
  Category(13,"part5", icon: FontAwesomeIcons.theaterMasks),
  Category(14,"part6", icon: FontAwesomeIcons.tv),
  Category(15,"part8", icon: FontAwesomeIcons.gamepad),
  Category(15,"part9", icon: FontAwesomeIcons.addressBook),

];

final List<Question> demoQuestions = Question.fromData([
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What does the \"MP\" stand for in MP3?",
    "correct_answer": "Moving Picture",
    "incorrect_answers": [
      "Music Player",
      "Multi Pass",
      "Micro Point"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What amount of bits commonly equals one byte?",
    "correct_answer": "8",
    "incorrect_answers": [
      "1",
      "2",
      "64"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which computer hardware device provides an interface for all other connected devices to communicate?",
    "correct_answer": "Motherboard",
    "incorrect_answers": [
      "Central Processing Unit",
      "Hard Disk Drive",
      "Random Access Memory"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "In web design, what does CSS stand for?",
    "correct_answer": "Cascading Style Sheet",
    "incorrect_answers": [
      "Counter Strike: Source",
      "Corrective Style Sheet",
      "Computer Style Sheet"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "What is the code name for the mobile operating system Android 7.0?",
    "correct_answer": "Nougat",
    "incorrect_answers": [
      "Ice Cream Sandwich",
      "Jelly Bean",
      "Marshmallow"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "On Twitter, what is the character limit for a Tweet?",
    "correct_answer": "140",
    "incorrect_answers": [
      "120",
      "160",
      "100"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which computer language would you associate Django framework with?",
    "correct_answer": "Python",
    "incorrect_answers": [
      "C#",
      "C++",
      "Java"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "boolean",
    "difficulty": "easy",
    "question": "The Windows 7 operating system has six main editions.",
    "correct_answer": "True",
    "incorrect_answers": [
      "False"
    ]
  },
  {
    "category": "Science: Computers",
    "type": "multiple",
    "difficulty": "easy",
    "question": "Which programming language shares its name with an island in Indonesia?",
    "correct_answer": "Java",
    "incorrect_answers": [
      "Python",
      "C",
      "Jakarta"
    ]
  }
]);