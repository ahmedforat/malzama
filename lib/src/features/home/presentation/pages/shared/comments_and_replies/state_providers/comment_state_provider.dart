import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/materialPage/state_provider_contracts/material_state_repo.dart';
import 'package:malzama/src/features/home/presentation/pages/my_materials/my_saved_and_uploads/my_saved_material/state_provider/saved_videos_state_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../../../core/api/api_client/clients/comments_client.dart';
import '../../../../../../../core/api/contract_response.dart';
import '../../../../../../../core/general_widgets/helper_functions.dart';
import '../../../../../models/material_author.dart';
import '../../../../../models/materials/study_material.dart';
import '../../../videos/videos_navigator/state/video_state_provider.dart';
import '../comment_related_models/comment_model.dart';
import '../comment_related_models/comment_rating_model.dart';
import '../comment_related_models/comment_reply_model.dart';
import 'add_comment_widget_state_provider.dart';

enum CommentStatus { SENT, IN_PROGRESS, FAILED, UPDATING, DELETING }

class CommentStateProvider<T extends MaterialStateRepository> with ChangeNotifier {
  BuildContext _context;

// =================================================================================================
  bool get isVideo => T is VideoStateProvider || T is MySavedVideoStateProvider;

  // ===============================================================================================
  /// current material state or object
  StudyMaterial state;

// =================================================================================================
  GlobalKey<ScaffoldState> _commentsScaffoldKey;

  GlobalKey<ScaffoldState> get commentsScaffoldKey => _commentsScaffoldKey;

  // =================================================================================================
  PageController pageController;

  // =================================================================================================
  CommentStatus _commentStatus;

  CommentStatus get commentStatus => _commentStatus;

  void setCommentStatusTo(CommentStatus update) {
    if (update != null) {
      _commentStatus = update;
      notifyMyListeners();
    }
  }

// =================================================================================================
  int _currentMaterialPos;

  int get currentMaterialPos => _currentMaterialPos;

// =================================================================================================
  // regarding showing the comment text field inside the bottom sheet that displays the comments
  bool _isAddCommentNavBarVisible = true;

  bool get isAddCommentNavBarVisible => _isAddCommentNavBarVisible;

  void setAddCommentNavBarVisibilityTo(bool update) {
    if (_isAddCommentNavBarVisible != update) {
      _isAddCommentNavBarVisible = update;
      notifyMyListeners();
    }
  }

  // =================================================================================================
// the count  of fetched comments
  int _fetchedCommentsCount = 0;

  // ================================================================================================
  CommentStateProvider({int materialPos, BuildContext context}) {
    _commentsScaffoldKey = GlobalKey<ScaffoldState>();
    print('commentsScaffoldKey created');
    this._currentMaterialPos = materialPos;

    this.state = Provider.of<T>(context, listen: false).materials[materialPos];

    pageController = new PageController();
    _context = context;
    print('new comment state provider of type $T has been created');
    setIsFetchingTo(true);
    fetchComments();
  }

  // ================================================================================================
  // to check if there are comments that are not fetched yet
  bool _anyMoreComments = false;

  bool get anyMoreComment => _anyMoreComments;

  // ================================================================================================

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setIsFetchingTo(bool update) {
    if (_isFetching != update) {
      _isFetching = update;
      notifyMyListeners();
    }
  }

  // ================================================================================================

  bool _isFetchingMore = false;

  bool get isFetchingMore => _isFetchingMore;

  void setIsFetchingMoreTo(bool update) {
    if (update != null) {
      _isFetchingMore = update;
      notifyMyListeners();
    }
  }

// ================================================================================================
  // control the view or load more comment clickable text
  void _updateAnyMoreComment() {
    bool previousAnymoreComments = _anyMoreComments;
    _fetchedCommentsCount = _comments.length;
    _anyMoreComments = state.comments.length != _fetchedCommentsCount;
    if (previousAnymoreComments != _anyMoreComments) {
      notifyMyListeners();
    }
  }

// ================================================================================================
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  // ================================================================================================

  void sortComments() {
    _comments.sort(
      (a, b) => DateTime.parse(a.postDate).compareTo(DateTime.parse(b.postDate)),
    );
  }

  // ================================================================================================

  void appendToComments(Comment update) {
    if (update != null) {
      _comments.add(update);
      sortComments();
      notifyMyListeners();
    }
  }

// ================================================================================================
  void removeCommentAt(int pos) {
    _comments.removeAt(pos);
    notifyMyListeners();
  }

// ================================================================================================
  String commentIdToBeUpdated;
  String replyIdToBeUpdated;
  String commentIdToBeDeleted;
  String replyIdToBeDeleted;

  // ================================================================================================

  // [ 0,1,2,3,4,5,,6,7,8]
  List<String> _getCommentsToFetch() {
    if (state.comments.isEmpty) {
      return [];
    }
    _fetchedCommentsCount = _comments.length;
    if (state.comments.length - _fetchedCommentsCount > 7) {
      return state.comments.reversed.toList().sublist(_fetchedCommentsCount, _fetchedCommentsCount + 7);
    }
    return state.comments.reversed.toList().sublist(_fetchedCommentsCount);
  }

  // ================================================================================================

  bool _isFirstTimeOpened = true;

  bool get isFirstTimeOpened => _isFirstTimeOpened;

  // ================================================================================================

  void breakComment(int commentPos) {
    this._comments[commentPos].breaked = !_comments[commentPos].breaked;
    notifyMyListeners();
  }

// ================================================================================================
  void breakReply(int commentPos, int replyPos) {
    this._comments[commentPos].replies[replyPos].breaked = !this._comments[commentPos].replies[replyPos].breaked;
  }

  // ================================================================================================
// ========================================  Functionalities ====================================
  // ================================================================================================
  // ================================================================================================

  // fetch comments
  Future<void> fetchComments() async {
    String collectionName = state.commentsCollection;
    List<String> ids = _getCommentsToFetch();
    if (ids.isEmpty) {
      setIsFetchingTo(false);
      return;
    }
    ContractResponse response = await CommentsClient().fetchComments(listOfIDs: ids.join(','), collection: collectionName);
    if (response is Success) {
      var fetchedComments = json.decode(response.message);
      print(fetchedComments);

      List<Comment> newFetchedComments = fetchedComments.map<Comment>((fetchedComment) => new Comment.fromJSON(fetchedComment)).toList();
      _comments = [...newFetchedComments, ..._comments];
      _updateAnyMoreComment();
      sortComments();
      _isFirstTimeOpened = true;
      if (_isFetching) {
        setIsFetchingTo(false);
      } else
        notifyMyListeners();
    }
  }

  // ================================================================================================
  Future<bool> uplaodNewComment({
    String content,
    bool resend = false,
    int pos,
  }) async {
    print('uploading new comment');
    if (!resend) {
      Comment newComment = new Comment(
          content: content,
          id: '',
          author: MaterialAuthor.fromJSON(await HelperFucntions.getAuthorPopulatedData()),
          collectionName: state.commentsCollection,
          materialID: state.id,
          postDate: DateTime.now().toIso8601String(),
          ratings: [],
          replies: [],
          hasRatings: false,
          hasReplies: false)
        ..commentStatus = CommentStatus.IN_PROGRESS
        ..breaked = shouldBeBreaked(content)
        ..breakable = shouldBeBreaked(content);

      appendToComments(newComment);
    } else {
      _comments[pos].commentStatus = CommentStatus.IN_PROGRESS;
      notifyMyListeners();
    }
    await Future.delayed(Duration(seconds: 2));
    ContractResponse response = await CommentsClient().createNewComment(commentData: state.newCommentData, content: content);

    if (response is Success) {
      print('******************** success');
      print(response.message);
      Map<String, dynamic> responseData = json.decode(response.message);
      Map<String, dynamic> newResponseData = {};
      responseData.entries.forEach((element) {
        newResponseData[element.key] = element.value;
      });

      newResponseData['newComment']['author'] = await HelperFucntions.getAuthorPopulatedData();

      _comments.removeWhere((comment) => comment.content == content);
      _comments.add(new Comment.fromJSON(newResponseData['newComment'])..commentStatus = CommentStatus.SENT);
      sortComments();

      Provider.of<T>(_context, listen: false).appendToComments(responseData['newComment']['_id'], _currentMaterialPos);
      notifyMyListeners();
      return true;
    }
    _comments.firstWhere((comment) => comment.content == content).commentStatus = CommentStatus.FAILED;
    notifyMyListeners();
    return false;
  }

// ================================================================================================
  Future<bool> _deleteComment({
    String commentId,
  }) async {
    _comments.firstWhere((comment) => comment.id == commentId).commentStatus = CommentStatus.DELETING;
    notifyMyListeners();
    ContractResponse response = await CommentsClient().deleteComment(queryString: state.commentDeletionQueryString, commentId: commentId);

    if (response is Success) {
      _comments.removeWhere((comment) => comment.id == commentId);
      notifyMyListeners();
      Provider.of<T>(_context, listen: false).removeFromComments(commentId, _currentMaterialPos);

      return true;
    } else {
      _comments.firstWhere((comment) => comment.id == commentId).commentStatus = CommentStatus.SENT;
      notifyMyListeners();
      return false;
    }
  }

  Future<void> commentOnDelete(int commentPos, int replyPos, bool mainComment) async {
    final String commentId = _comments[mainComment ? _repliesRelevantCommentPos : commentPos].id;

    /// deleting a reply

    if (_insideRepliesPage && !mainComment) {
      replyIdToBeDeleted = _comments[_repliesRelevantCommentPos].replies[replyPos].id;

      final bool result = await _deleteReply(
        commentID: commentId,
        replyID: replyIdToBeDeleted,
      );
      final String message = result ? 'reply deleted' : ' reply failed to be deleted';
      _commentsScaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
    } else {
      print('deleting entire comment');
      replyIdToBeDeleted = null;
      final bool result = await _deleteComment(commentId: commentId);
      if (result && _insideRepliesPage && mainComment) {
        closeRepliesDisplayPage();
        notifyMyListeners();
      }
      final String message = result ? 'comment deleted' : 'comment failed to be deleted';
      _commentsScaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

// ================================================================================================
  Future<void> uploadNewReply({@required String content, @required BuildContext context}) async {
    CommentReply newReply = new CommentReply(
      author: MaterialAuthor.fromJSON(await HelperFucntions.getAuthorPopulatedData()),
      content: content,
      postDate: '',
      id: '',
    )
      ..commentStatus = CommentStatus.IN_PROGRESS
      ..breakable = shouldBeBreaked(content)
      ..breaked = shouldBeBreaked(content);

    _comments[_repliesRelevantCommentPos].replies.add(newReply);
    notifyMyListeners();

    ContractResponse contractResponse = await CommentsClient().createNewReply(
      replyData: state.newReplyData,
      commentId: _comments[_repliesRelevantCommentPos].id,
      replyContent: content,
    );

    if (contractResponse is Success) {
      var responseBody = json.decode(contractResponse.message);
      print('====================================');
      print(responseBody);
      print('====================================');

      _comments[_repliesRelevantCommentPos].hasReplies = true;
      _comments[_repliesRelevantCommentPos].replies.firstWhere((reply) => reply.content == content)
        ..postDate = DateTime.fromMillisecondsSinceEpoch(responseBody['newReply']['post_date']).toIso8601String()
        ..id = responseBody['newReply']['_id']
        ..commentStatus = CommentStatus.SENT;
      notifyMyListeners();
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Failed to send reply')));
    }
  }

// ================================================================================================
  Future<dynamic> editCommentOrReply({@required BuildContext context}) async {
    AddOrEditCommentWidgetStateProvider addOrEditCommentWidgetStateProvider =
        Provider.of<AddOrEditCommentWidgetStateProvider>(context, listen: false);

    if (_insideRepliesPage && replyIdToBeUpdated != null) {
      _comments[_repliesRelevantCommentPos].replies.firstWhere((reply) => reply.id == replyIdToBeUpdated).commentStatus =
          CommentStatus.UPDATING;
    } else {
      _comments.firstWhere((comment) => comment.id == commentIdToBeUpdated).commentStatus = CommentStatus.UPDATING;
    }
    notifyMyListeners();
    final String content = addOrEditCommentWidgetStateProvider.textController.text;
    //addOrEditCommentWidgetStateProvider.resetWidget();
    ContractResponse contractResponse;
    if (replyIdToBeUpdated != null) {
      contractResponse = await CommentsClient().editReply(
        commentsCollection: state.commentsCollection,
        commentId: commentIdToBeUpdated,
        replyId: replyIdToBeUpdated,
        replyContent: content,
      );
    } else {
      contractResponse = await CommentsClient().editComment(
        commentsCollection: state.commentsCollection,
        commentId: commentIdToBeUpdated,
        commentContent: content,
      );
    }

    if (contractResponse is Success) {
      addOrEditCommentWidgetStateProvider.resetWidget();

      if (replyIdToBeUpdated != null) {
        _comments[repliesRelevantCommentPos].replies.firstWhere((reply) => reply.id == replyIdToBeUpdated)
          ..commentStatus = CommentStatus.SENT
          ..content = content;
      } else {
        _comments.firstWhere((comment) => comment.id == commentIdToBeUpdated)
          ..commentStatus = CommentStatus.SENT
          ..content = content;
      }

      commentIdToBeUpdated = null;
      replyIdToBeUpdated = null;
      notifyMyListeners();
    }
  }

// ================================================================================================
  Future<bool> _deleteReply({
    String commentID,
    String replyID,
  }) async {
    _comments.firstWhere((comment) => comment.id == commentID).replies.firstWhere((reply) => reply.id == replyID).commentStatus =
        CommentStatus.DELETING;
    notifyMyListeners();
    ContractResponse response =
        await CommentsClient().deleteReply(commentsCollection: state.commentsCollection, commentId: commentID, replyId: replyID);
    if (response is Success) {
      final int currentCommentPos = repliesRelevantCommentPos;
      comments[currentCommentPos].replies.removeWhere((reply) => reply.id == replyIdToBeDeleted);
      comments[currentCommentPos].hasReplies = comments[currentCommentPos].replies.length > 0;
      notifyMyListeners();
      return true;
    }
    _comments.firstWhere((comment) => comment.id == commentID).replies.firstWhere((reply) => reply.id == replyID).commentStatus =
        CommentStatus.SENT;
    notifyMyListeners();
    return false;
  }

// ================================================================================================
  // Future<String> editComment(@required String newContent) async {
  //   _comments.firstWhere((comment) => comment.id == commentIdToBeUpdated)
  //     ..content = newContent
  //     ..breakable = shouldBeBreaked(newContent)
  //     ..commentStatus = CommentStatus.SENT;
  //   notifyMyListeners();
  // }

  void setState() {
    notifyMyListeners();
  }

// ================================================================================================
  /// this is the pos of the comment that will be displayed in the replies display page;
  int _repliesRelevantCommentPos;

  int get repliesRelevantCommentPos => _repliesRelevantCommentPos;

  void updateRepliesRelevantCommentPos(int update) {
    if (update != null) {
      _repliesRelevantCommentPos = update;
      notifyMyListeners();
    }
  }

// ================================================================================================
  /// comment rating
  void setRatingOfCommentTo(
      {int commentPos, bool rating, String myId, CommentRating myRating, Comment comment, MaterialAuthor materialAuthor}) async {
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

    notifyMyListeners();



    ContractResponse response = await CommentsClient().rateComment(
      commentId: comment.id,
      ratingId: myRating == null ? null : myRating.id,
      newRating: rating,
      ratingQueryString: state.commentRatingQueryString,
    );
    if (response is Success201) {
      // TODO:implement sending the notifications body to the specific user
    }
  }

// ================================================================================================
  /// this is to check whether we are inside a replies page or not
  /// to handle methods that might be used inside replies display page
  /// and comments display page such as delete or even edit methods
  bool _insideRepliesPage = false;

  bool get insideRepliesPage => _insideRepliesPage;

  updateWhetherInsideRepliesPageOrNot(bool update) {
    if (update != null) {
      _insideRepliesPage = update;
      notifyMyListeners();
    }
  }

// ================================================================================================

// ================================================================================================

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

// ================================================================================================

  bool _isDisposed = false;

  void notifyMyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    print('TextEditingController of comment TextField has been dispoed');
    print('FocusNode of comment TextField  has been dispoed');
    print('comment state provider has been dispoed');
    pageController.dispose();
    print('Page Controller has been disposed');
    super.dispose();
  }
// ================================================================================================
}
