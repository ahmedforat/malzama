import 'package:flutter/cupertino.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/comment_state_provider.dart';

import '../../../../../models/material_author.dart';
import 'comment_rating_model.dart';
import 'comment_reply_model.dart';

class Comment {
  String postDate;
  String collectionName, content, materialID, id;
  MaterialAuthor author;
  List<CommentReply> replies;
  List<CommentRating> ratings;
  bool breakable;
  bool breaked;
  CommentStatus commentStatus;

  Comment({
    @required this.postDate,
    @required this.collectionName,
    @required this.content,
    @required this.materialID,
    @required this.id,
    @required this.author,
    @required this.replies,
    @required this.ratings,
  });

  Comment.fromJSON(Map<String, dynamic> map)
      : this.postDate = map['post_date'],
        this.collectionName = map['collection_name'],
        this.content = map['content'],
        this.materialID = map['material_id'],
        this.id = map['_id'],
        this.author = MaterialAuthor.fromJSON(map['author']),
        this.replies = map['replies'].map<CommentReply>((reply) => CommentReply.fromJSON(reply)).toList(),
        this.ratings = map['ratings'].map<CommentRating>((rating) => CommentRating.fromJSON(rating)).toList(),
        this.breakable = shouldBeBreaked(map['content']),
        this.breaked = shouldBeBreaked(map['content']);

  Map<String, dynamic> toJSON() => {
        'post_date': postDate,
        'collection_name': collectionName,
        'content': content,
        'material_id': materialID,
        '_id': id,
        'author': author.toJSON(),
        'replies': replies.map((reply) => reply.toJSON()).toList(),
        'ratings': ratings.map((rating) => rating.toJSON()).toList(),
      };


}

bool shouldBeBreaked(String text) {
  List<int> breaksAddresses = [];

  for (int i = 0; i < text.length; i++) {
    if (text[i] == '\n') {
      breaksAddresses.add(i);
    }
  }

  return (breaksAddresses.length > 2 && hasSequentialBreaks(breaksAddresses)) || text.length > 200;
}
//  1  ,  2  , 4,  5 ,  7  ,8,9
bool hasSequentialBreaks(List<int> breaks) {
  int indicator = 1;
  int start = breaks.first;
  for (int i = 1; i < breaks.length; i++) {
    if (breaks[i] - breaks[i - 1] == 1) {
      indicator += 1;
    } else {
      start = breaks[i];
      indicator = 1;
    }
  }

  return indicator >= 5 && start < 50;
}
