import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/state_providers/comment_state_provider.dart';

import '../../../../../models/material_author.dart';
import 'comment_model.dart';

/**
 *  reply_author: Schema.Types.ObjectId,
    content: String,
    post_date: {
    type: Date,
    default: Date.now(),
    },
 */
class CommentReply {
  MaterialAuthor author;
  String content;
  String postDate;
  String id;
  bool breakable;
  bool breaked;

  CommentStatus commentStatus;

  CommentReply({
    @required this.author,
    @required this.content,
    @required this.postDate,
    @required this.id,

  });

  CommentReply.fromJSON(Map<String, dynamic> map)
      : this.author = MaterialAuthor.fromJSON(map['reply_author']),
        this.content = map['content'],
        this.postDate = map['post_date'],
        this.id = map['_id'],
        this.breakable = shouldBeBreaked(map['content']),
        this.breaked = shouldBeBreaked(map['content']);


  Map<String, dynamic> toJSON() => {
        'reply_author': author.toJSON(),
        'content': content,
        'post_date': postDate,
        '_id': id,
      };
}
