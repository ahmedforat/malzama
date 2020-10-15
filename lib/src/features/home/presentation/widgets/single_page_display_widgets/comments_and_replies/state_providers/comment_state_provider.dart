import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/core/api/http_methods.dart';

import 'package:malzama/src/core/api/routes.dart';
import 'package:malzama/src/core/platform/services/caching_services.dart';
import 'package:malzama/src/core/platform/services/file_system_services.dart';
import 'package:malzama/src/features/home/models/material_author.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/comment_related_models/comment_rating_model.dart';
import 'package:malzama/src/features/home/presentation/widgets/single_page_display_widgets/comments_and_replies/functions/replies_functions.dart';

import '../../../../../../../../src/core/api/contract_response.dart';
import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../../../core/platform/local_database/models/base_model.dart';
import '../comment_related_models/comment_model.dart';
import '../functions/comments_functions.dart';

/**
 * CommentWidget(
    focusNode: _focusNode,
    commentPos: pos,
    materialPos: widget.materialPos,
    isVideo: widget.isVideo,
    textEditingController: _textEditingController,
    ),
 */

enum CommentStatus { SENT, IN_PROGRESS, FAILED, UPDATING, DELETING }

class CommentStateProvider with ChangeNotifier {


  PageController pageController;

  // ====================================================================================
  CommentStatus _commentStatus;

  CommentStatus get commentStatus => _commentStatus;

  void setCommentStatusTo(CommentStatus update) {
    if (update != null) {
      _commentStatus = update;
      notifyListeners();
    }
  }

  int _currentMaterialPos;
  bool _isVideo;

  int get currentMaterialPos => _currentMaterialPos;

  bool get isVideo => _isVideo;

  // regarding showing the comment text field inside the bottom sheet that displays the comments
  bool _isAddCommentNavBarVisible = true;

  bool get isAddCommentNavBarVisible => _isAddCommentNavBarVisible;

  void setAddCommentNavBarVisibilityTo(bool update) {
    if (_isAddCommentNavBarVisible != update) {
      _isAddCommentNavBarVisible = update;
      notifyListeners();
    }
  }

  // ===================================================================================

  var state;
  int _fetchedCommentsCount = 0;

  CommentStateProvider({this.state, bool isVideo, int materialPos}) {
    this._currentMaterialPos = materialPos;
    this._isVideo = isVideo;
    pageController = new PageController();

    print('new comment state provider has been created');
    setIsFetchingTo(true);
    fetchComments();
  }

  // to check if there are comments that are not fetched yet
  bool _anyMoreComments = false;

  bool get anyMoreComment => _anyMoreComments;

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  bool _isFetchingMore = false;

  bool get isFetchingMore => _isFetchingMore;

  void setIsFetchingMoreTo(bool update) {
    if (update != null) {
      _isFetchingMore = update;
      notifyListeners();
    }
  }

  void setIsFetchingTo(bool update) {
    if (_isFetching != update) {
      _isFetching = update;
      notifyListeners();
    }
  }

  // control the view or load more comment clickable text
  void _updateAnyMoreComment() {
    bool previousAnymoreComments = _anyMoreComments;
    _fetchedCommentsCount = _comments.length;
    _anyMoreComments = state.comments.length != _fetchedCommentsCount;
    if (previousAnymoreComments != _anyMoreComments) {
      notifyListeners();
    }
  }

  List<Comment> _comments = [];

  List<Comment> get comments => _comments;



  void sortComments() {
    _comments.sort(
      (a, b) => DateTime.parse(a.postDate).compareTo(DateTime.parse(b.postDate)),
    );
    ;
  }

  void appendToComments(Comment update) {
    if (update != null) {
      _comments.add(update);
      sortComments();
      notifyListeners();
    }
  }

  void removeCommentAt(int pos) {
    if (pos != null) {
      _comments.removeAt(pos);
      sortComments();
      notifyListeners();
    }
  }

  String commentIdToBeUpdated;
  String replyIdToBeUpdated;
  String commentIdToBeDeleted;
  String replyIdToBeDeleted;

  // [ 0,1,2,3,4,5,,6,7,8]
  List<String> _getCommentsToFetch() {
    _fetchedCommentsCount = _comments.length;
    if (state.comments.length - _fetchedCommentsCount > 7) {
      return (state.comments as List<String>).reversed.toList().sublist(_fetchedCommentsCount, _fetchedCommentsCount + 7);
    }
    return (state.comments as List<String>).reversed.toList().sublist(_fetchedCommentsCount);
  }

  bool _isFirstTimeOpened = true;

  bool get isFirstTimeOpened => _isFirstTimeOpened;

  void breakComment(int commentPos) {
    this._comments[commentPos].breaked = !_comments[commentPos].breaked;
    notifyListeners();
  }

  void breakReply(int commentPos, int replyPos) {
    this._comments[commentPos].replies[replyPos].breaked = !this._comments[commentPos].replies[replyPos].breaked;
  }

  // fetch comments
  Future<void> fetchComments() async {
    ContractResponse response = await CommentFunctions.fetchCommentsFromApi(state, _getCommentsToFetch());
    if (response is Success) {
      var fetchedComments = json.decode(response.message);
      print(fetchedComments);
      List<Comment> newFetchedComments = fetchedComments.map<Comment>((fetchedComment) => new Comment.fromJSON(fetchedComment))
          .toList();
      _comments = [...newFetchedComments, ..._comments];
      _updateAnyMoreComment();
      sortComments();
      _isFirstTimeOpened = true;
      if (_isFetching) {
        setIsFetchingTo(false);
      } else
        notifyListeners();
    }
  }

  Future<String> uplaodNewComment({
    String content,
    BaseUploadingModel materialInfo,
    bool resend = false,
    int pos,
  }) async {
    final userData = await FileSystemServices.getUserData();

    print('uploading new comment');
    if (!resend) {
      Comment newComment = new Comment(
        content: content,
        id: '',
        author: MaterialAuthor.fromJSON(await HelperFucntions.getAuthorPopulatedData()),
        collectionName: materialInfo.comments_collection,
        materialID: materialInfo.material_id,
        postDate: DateTime.now().toIso8601String(),
        ratings: [],
        replies: [],
        hasRatings: false,
        hasReplies: false
      )
        ..commentStatus = CommentStatus.IN_PROGRESS
        ..breaked = shouldBeBreaked(content)
        ..breakable = shouldBeBreaked(content);

      appendToComments(newComment);
    } else {
      _comments[pos].commentStatus = CommentStatus.IN_PROGRESS;
      notifyListeners();
    }
    await Future.delayed(Duration(seconds: 2));
    ContractResponse response = await CommentFunctions.uploadNewComment(
      content: content,
      materialInfo: materialInfo,
    );
    /**
     * "post_date": "2020-08-20T18:42:17.028Z",
        "collection_name": "uniLecturesComments",
        "_id": "5f3ec4091c359e5e3c75570b",
        "author": "5f2c08057d9f3952987971b2",
        "content": "first comment",
        "lecture": "5f2c08607d9f3952987971b4",
        "ratings": [],
        "replies": [],
     */
    if (response is Success) {
      print('******************** success');
      print(response.message);
      Map<String, dynamic> responseData = json.decode(response.message);
      Map<String, dynamic> newResponseData = {};
      responseData.entries.forEach((element) {
        newResponseData[element.key] = element.value;
      });
      print('قبل لتخرب بثواني');
      newResponseData.entries.forEach((element) {
        print(element);
      });

      newResponseData['newComment']['author'] = await HelperFucntions.getAuthorPopulatedData();

      _comments.removeWhere((comment) => comment.content == content);
      _comments.add(new Comment.fromJSON(newResponseData['newComment'])..commentStatus = CommentStatus.SENT);
      sortComments();
      notifyListeners();
      return responseData['newComment']['_id'];
    }
    _comments.firstWhere((comment) => comment.content == content).commentStatus = CommentStatus.FAILED;
    notifyListeners();
    return null;
  }

  Future<String> deleteComment({
    String comment_id,
    BaseUploadingModel materialInfo,
  }) async {
    _comments.firstWhere((comment) => comment.id == comment_id).commentStatus = CommentStatus.DELETING;
    notifyListeners();
    ContractResponse response = await CommentFunctions.deleteComment(materialInfo: materialInfo, comment_id: comment_id);
    if (response is! Success) {
      _comments.firstWhere((comment) => comment.id == comment_id).commentStatus = CommentStatus.SENT;
      notifyListeners();
      return null;
    }
    return 'comment deleted';
  }

  Future<String> deleteReply({
    String commentID,
    BaseUploadingModel baseUploadingModel,
    String replyID,
  }) async {
    _comments.firstWhere((comment) => comment.id == commentID).replies.firstWhere((reply) => reply.id == replyID).commentStatus =
        CommentStatus.DELETING;
    notifyListeners();
    ContractResponse response = await RepliesFunctions.deleteReply(commentId: commentID, replyId: replyID, material: baseUploadingModel);
    if (response is! Success) {
      _comments.firstWhere((comment) => comment.id == commentID).replies.firstWhere((reply) => reply.id == replyID).commentStatus =
          CommentStatus.SENT;
      notifyListeners();
      return null;
    }
    return 'reply deleted';
  }

  Future<String> editComment(@required String newContent) async {
    _comments.firstWhere((comment) => comment.id == commentIdToBeUpdated)
      ..content = newContent
      ..breakable = shouldBeBreaked(newContent)
      ..commentStatus = CommentStatus.SENT;
    notifyListeners();
  }

  void setState() {
    notifyListeners();
  }

  // ===============================================================================
  /// this is the pos of the comment that will be displayed in the replies display page;
  int _repliesRelevantCommentPos;

  int get repliesRelevantCommentPos => _repliesRelevantCommentPos;

  void updateRepliesRelevantCommentPos(int update) {
    if (update != null) {
      _repliesRelevantCommentPos = update;
      notifyListeners();
    }
  }

  // ==================================================================================
  /// comment rating
  void setRatingOfCommentTo(
      {int commentPos,
      bool rating,
      String myId,
      CommentRating myRating,
      Comment comment,
      BaseStateProvider material,
      MaterialAuthor materialAuthor}) async {
    if (myRating != null) {
      if (rating == myRating.ratingType) {
        // remove the rating
        _comments[commentPos].ratings.removeWhere((rating) => rating.author.id == myId);
        _comments[commentPos].hasRatings = _comments[commentPos].ratings.length > 0;
      } else {
        // update the already existing rating
        _comments[commentPos].ratings.firstWhere((rating) => rating.author.id == myId).ratingType = rating;
      }
    } else {
      // append new rating
      CommentRating newCommentRating = new CommentRating(ratingType: rating, author: materialAuthor, id: myId);
      _comments[commentPos].ratings.add(newCommentRating);
      _comments[commentPos].hasRatings = true;
    }

    notifyListeners();

    final body = {
      'comments_collection': comment.collectionName,
      'comment_id': comment.id,
      'newRating': rating,
      'rating_id': myRating == null ? null : myRating.id,
      'material_id': material.materialItems[currentMaterialPos].material_id,
      'material_collection': material.materialItems[currentMaterialPos].material_collection,
      'author_id': material.materialItems[currentMaterialPos].author['_id'],
      'author_notifications_repo': material.materialItems[currentMaterialPos].author['notifications_repo'],
      'author_one_signal_id': material.materialItems[currentMaterialPos].author['one_signal_id']
    };

    ContractResponse response = await HttpMethods.post(body: body, url: Api.RATE_COMMENT);
    if (response is Success201) {
      // TODO:implement sending the notifications body to the specific user
    }
  }

  // ===============================================================================
  /// this is to check whether we are inside a replies page or not
  /// to handle methods that might be used inside replies display page
  /// and comments display page such as delete or even edit methods
  bool _insideRepliesPage = false;

  bool get insideRepliesPage => _insideRepliesPage;

  updateWhetherInsideRepliesPageOrNot(bool update) {
    if (update != null) {
      _insideRepliesPage = update;
      notifyListeners();
    }
  }

  // ==================================================================================

  // =================================================================================

  /// methods to open and close replies display page
  ///
  /// open replies display page
  void displayRepliesOfTheComment(int commentPos) {
    updateRepliesRelevantCommentPos(commentPos);
    updateWhetherInsideRepliesPageOrNot(true);
    pageController.animateToPage(1, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);

  }

  /// close replies display page and head back to the comments display page
  closeRepliesDisplayPage() {
    updateWhetherInsideRepliesPageOrNot(false);
    pageController.animateToPage(0, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

// =================================================================================
  @override
  void dispose() {
    print('TextEditingController of comment TextField has been dispoed');
    print('FocusNode of comment TextField  has been dispoed');
    print('comment state provider has been dispoed');
    pageController.dispose();
    print('Page Controller has been disposed');
    super.dispose();
  }
}
