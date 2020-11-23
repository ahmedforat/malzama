import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/contract_response.dart';
import 'package:malzama/src/core/api/http_methods.dart';
import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/features/home/models/materials/study_material.dart';

import '../repositories/comments_repository.dart';

class CommentsApiClient implements CommentsRepository {
  @override // [✔]
  Future<ContractResponse> createNewComment({@required Map<String, String> commentData, @required String content}) async {

    Map<String, dynamic> body = {
      'content': content,
    }..addAll(commentData);

    return HttpMethods.post(body: body, url: Api.UPLOAD_COMMENT);
  }

  @override // [✔]
  Future<ContractResponse> createNewReply({
    @required Map<String, String> replyData,
    @required String commentId,
    @required String replyContent,
  }) async {
    Map<String, dynamic> body = {
      'reply_content': replyContent,
      'comment_id': commentId,
    }..addAll(replyData);

    return await HttpMethods.post(body: body, url: Api.UPLOAD_NEW_REPLY);
  }

  @override // [✔]
  Future<ContractResponse> deleteComment({@required String queryString, @required String commentId}) async {
    final String modifiedQueryString = queryString + '&commentId=$commentId';
    return await HttpMethods.get(url: Api.DELETE_COMMENT, queryString: modifiedQueryString);
  }

  @override // [✔]
  Future<ContractResponse> deleteReply({
    @required String commentsCollection,
    @required String commentId,
    @required replyId,
  }) async {
    final String queryString = '?commentsCollection=$commentsCollection&commentId=$commentId&replyId=$replyId';
    return await HttpMethods.get(url: Api.DELETE_REPLY, queryString: queryString);
  }

  @override // [✔]
  Future<ContractResponse> editComment({
    @required String commentsCollection,
    @required String commentId,
    @required String commentContent,
  }) async {
    Map<String, dynamic> body = {
      'comments_collection': commentsCollection,
      'comment_id': commentId,
      'comment_content': commentContent,
    };

    return await HttpMethods.post(body: body, url: Api.EDIT_COMMENT);
  }

  @override // [✔]
  Future<ContractResponse> editReply({
    @required String commentsCollection,
    @required String commentId,
    @required String replyId,
    @required String replyContent,
  }) async {
    Map<String, dynamic> body = {
      'comments_collection': commentsCollection,
      'comment_id': commentId,
      'reply_id': replyId,
      'reply_content': replyContent,
    };

    return await HttpMethods.post(body: body, url: Api.EDIT_REPLY);
  }

  @override // [✔]
  Future<ContractResponse> fetchComments({String collection, String listOfIDs}) async {
    final String queryString = '?collection=$collection&ids=$listOfIDs';
    return await HttpMethods.get(url: Api.FETCH_COMMENTS_BY_IDS, queryString: queryString);
  }

  @override // [✔]
  Future<ContractResponse> rateComment({
    @required String commentId,
    @required String ratingId,
    @required bool newRating,
    @required String ratingQueryString,
  }) async {
    final queryString = ratingQueryString + '&commentId=$commentId&ratingId=$ratingId&newRating=$newRating';
    return await HttpMethods.get(url: Api.RATE_COMMENT, queryString: queryString);
  }
}
