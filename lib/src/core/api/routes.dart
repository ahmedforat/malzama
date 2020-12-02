import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';

class Api {
  static final Map<String, String> mainRoutes = {
    'schteachers': '/api/v1/sch-teacher',
    'schstudents': '/api/v1/sch-student',
    'uniteachers': '/api/v1/uni-teacher',
    'unistudents': '/api/v1/uni-student'
  };

  /// Basics
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  ///  signup url
  /// => [ _LOCALHOST_URL + '/registration/signup' ]
  static const String SIGNUP_URL = _LOCALHOST_URL + '/registration/signup';

  /// login url
  ///  => [ _LOCALHOST_URL + '/registration/login' ]
  static const String LOGIN_URL = _LocalServer + '/registration/login';

  /// verify email url
  /// => [ _LOCALHOST_URL + '/registration/check-verification' ]
  static const String VERIFY_EMAIL_URL = _LOCALHOST_URL + '/registration/check-verification';

  /// send another verification auth code
  ///  => [ _LOCALHOST_URL + '/registration/send-another-auth-code' ]
  static const String SEND_ANOTHER_AUTH_CODE_URL = _LOCALHOST_URL + '/registration/send-another-auth-code';

  // ==========================================================================================================================

  // Materials usecases

  // Common

  /// upload new material videos pdfs or quizes => [ _LOCALHOST_URL + '/materials/common/new' ]
  static const String UPLOAD_NEW_MATERIAL = _LOCALHOST_URL + '/materials/common/new';

  ///  delete entire material pdf or video or even entire quiz collection => ['/materials/common/delete']
  static const String DELETE_MATERIAL = _LOCALHOST_URL + '/materials/common/delete';

  /// edit a material video or pdf or entire quiz =>  ['/materials/common/edit']
  static const String EDIT_MATERIAL = _LOCALHOST_URL + '/materials/common/edit';

  /// add a material to user saved items => ['/materials/common/save']
  static const String MARK_MATERIAL_AS_SAVED = _LOCALHOST_URL + '/materials/common/save';

  // ///  fetch materials for videos and lectures only => ['/materials/videos-and-pdfs/fetch-material']
  // static const String _FETCH_MATERIALS = _LOCALHOST_URL + '/materials/fetch-material';

  // ==========================================================================================================================

  // [Videos and PDFs]

  // fetch by id
  /// fetch single video or lecture by id => [/materials/videos-and-pdfs/fetchById]
  static const String FETCH_VIDEO_OR_PDF_BY_ID = _LOCALHOST_URL + '/materials/videos-and-pdfs/fetchById';

  // fetch for Pagination
  /// fetch videos or lectures in pagination style => [/materials/videos-and-pdfs/fetch]
  static const String FETCH_VIDEOS_OR_PDFS = _LOCALHOST_URL + '/materials/videos-and-pdfs/fetch';

  /// fetch saved videos or pdfs => ['/fetch-saved-materials']
  static const String FETCH_SAVED_VIDEOS_OR_PDFS = _LOCALHOST_URL + '/materials/videos-and-pdfs/fetch-saved-materials';

  // ==========================================================================================================================

  // quizes usecases

  /// fetch headers of quizes i.e (quizes without questions just credentials) => ['/materials/quizes/fetch-quizes-headers']
  static const String FETCH_QUIZES_HEADERS = _LOCALHOST_URL + '/materials/quizes/fetch-quizes-headers';

  /// fetch quiz questions in pagination style => ['/materials/quizes/fetch-quiz-questions']
  static const String FETCH_QUIZES_QUESTIONS = _LOCALHOST_URL + '/materials/quizes/fetch-quiz-questions';

  ///  fetch total quizes count => ['/materials/quizes/fetch-quizes-count']
  static const String FETCH_QUIZES_COUNT = _LOCALHOST_URL + '/materials/quizes/fetch-quizes-count';

  /// edit single quiz item or question => ['/materials/quizes/edit-quiz-item']
  static const String EDIT_QUIZ_ITEM = _LOCALHOST_URL + '/materials/quizes/edit-quiz-item';

  /// delete single quiz item or question => ['/materials/quizes/delete-quiz-item']
  static const String DELETE_QUIZ_ITEM = _LOCALHOST_URL + '/materials/quizes/delete-quiz-item';

  /// fetch single quiz collection => ['/materials/quizes/fetchById']
  static const String FETCH_QUIZ_BY_ID = _LOCALHOST_URL + '/materials/quizes/fetchById';

  /// fetch saved quizes headers => ["/fetch-saved-quizes-headers"]
  static const String FETCH_SAVED_QUIZES_HEADERS = _LOCALHOST_URL + '/materials/quizes/fetch-saved-quizes-headers';

// ==========================================================================================================================

// Comments UseCases

  /// fetch comments by ids => ['/comments/fetch-comments']
  static const String FETCH_COMMENTS_BY_IDS = _LOCALHOST_URL + '/comments/fetch-comments';

  /// upload comment => ['/comments/new-comment']
  static const String UPLOAD_COMMENT = _LOCALHOST_URL + '/comments/new-comment';

  /// upload comment => ['/comments/edit-comment']
  static const String EDIT_COMMENT = _LOCALHOST_URL + '/comments/edit-comment';

  /// delete comment => ['/comments/delete-comment']
  static const String DELETE_COMMENT = _LOCALHOST_URL + '/comments/delete-comment';

  /// rate a comment => ['/comments/rate-comment']
  static const String RATE_COMMENT = _LOCALHOST_URL + '/comments/rate-comment';

  // =================================================================================
  /// Replies

  /// upload new reply to a comment => ['/comments/new-reply']
  static const String UPLOAD_NEW_REPLY = _LOCALHOST_URL + '/comments/new-reply';

  /// edit a reply to a comment => ['/comments/edit-reply']
  static const String EDIT_REPLY = _LOCALHOST_URL + '/comments/edit-reply';

  /// delete a reply to a comment => ['/comments/delete-reply']
  static const String DELETE_REPLY = _LOCALHOST_URL + '/comments/delete-reply';

  // =================================================================================

// =========================================================================
  // quizes

  /*[X]*/

  static String getSuitableUrl({String accountType, bool fromCloud = true}) {
    return '$_LOCALHOST_URL' + mainRoutes[accountType];
  }
}
