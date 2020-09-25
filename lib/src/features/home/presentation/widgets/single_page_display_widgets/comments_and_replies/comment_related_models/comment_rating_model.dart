import 'package:flutter/cupertino.dart';

import '../../../../../models/material_author.dart';

class CommentRating {
  bool ratingType;
  MaterialAuthor author;
  String id;

  CommentRating({
    @required this.ratingType,
    @required this.author,
    @required this.id,
  });

  CommentRating.fromJSON(Map<String, dynamic> map)
      : this.ratingType = map['rating_type'],
        this.author = MaterialAuthor.fromJSON(map['rating_author']),
        this.id = map['_id'];

  Map<String, dynamic> toJSON() => {
        'rating_type': ratingType,
        'rating_author': author,
        '_id':id
      };
}
