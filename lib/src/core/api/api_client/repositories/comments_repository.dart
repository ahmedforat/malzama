import 'package:flutter/foundation.dart';
import '../../contract_response.dart';


abstract class CommentsRepository {
  /// [Create New Comment]
  /// {content:content}..addAll(commentData) ........... [POST req]
  Future<ContractResponse> createNewComment({
    @required Map<String, String> commentData,
    @required String content,
  });

  ///  [Edit Comment] /
  /// [  require] materialCollection,materialId,commentsCollection,commentId [as query string]
  ///  all named in camelCase ..................... [GET req]
  Future<ContractResponse> deleteComment({
    @required String queryString,
    @required String commentId,
  });


  /// [Edit an already existing comment]
  /// {comments_collection,comment_id,comment_content} ........... [POST req]
  Future<ContractResponse> editComment({
    @required String commentsCollection,
    @required String commentId,
    @required String commentContent,
  });


  /// [create a new reply to a comment] [...... POST HTTP request]
  /// {reply_content}..addAll(replyData..add(comment_id) ........... [POST req]
   Future<ContractResponse> createNewReply({
     @required Map<String,String> replyData,
     @required String commentId,
     @required String replyContent
});

  /// [delete a reply to a comment]
  /// [require] commentsCollection,replyId,commentId [as query string] named as camelCase
  ///  ..................... [GET req]
  Future<ContractResponse> deleteReply({
    @required String commentsCollection,
    @required String commentId,
    @required replyId
  });


  /// edit a reply ........... [POST req]
  Future<ContractResponse> editReply({
    @required String commentsCollection,
    @required String commentId,
    @required String replyId,
    @required String replyContent,
  });



  /// [rate a comment]  ..................... [GET req]
  Future<ContractResponse> rateComment({
    @required String commentId,
    @required String ratingId,
    @required bool newRating,
    @required String ratingQueryString,
});


  /// [Fetch Comments ]........... [GET req]
Future<ContractResponse> fetchComments({
  @required String collection,
  @required String listOfIDs,
});

}
