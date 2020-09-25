import 'package:flutter/cupertino.dart';
import 'package:malzama/src/core/general_widgets/helper_functions.dart';

class Api {
  static final Map<String, String> mainRoutes = {
    'schteachers': '/api/v1/sch-teacher',
    'schstudents': '/api/v1/sch-student',
    'uniteachers': '/api/v1/uni-teacher',
    'unistudents': '/api/v1/uni-student'
  };

  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';

  // signup url
  static const String SIGNUP_URL = _LOCALHOST_URL + '/registration/signup';

  // login url
  static const String LOGIN_URL = _LOCALHOST_URL + '/registration/login';

  // verify email url
  static const String VERIFY_EMAIL_URL = _LOCALHOST_URL + '/registration/check-verification';

  // send another verification auth code
  static const String SEND_ANOTHER_AUTH_CODE_URL = _LOCALHOST_URL + '/registration/send-another-auth-code';

  // upload new material videos pdfs or quizes
  static const String UPLOAD_NEW_MATERIAL = _LOCALHOST_URL + '/uploading/new-material';

  // fetch Lectures
  static const String _FETCH_MATERIALS = _LOCALHOST_URL + '/material-interactions/fetch-material/';

  // fetch comments by ids
  static const String FETCH_COMMENTS_BY_IDS = _LOCALHOST_URL + '/comments/fetch-comments';

  // delete comment
  static const String DELETE_COMMENT = _LOCALHOST_URL + '/comments/delete-comment';

  // upload comment
  static const String UPLOAD_COMMENT = _LOCALHOST_URL + '/comments/new-comment';

  // upload comment
  static const String EDIT_COMMENT = _LOCALHOST_URL + '/comments/edit-comment';

  // =================================================================================
  /// Replies

  // upload new reply to a comment
  static const String UPLOAD_NEW_REPLY = _LOCALHOST_URL + '/comments/new-reply';

  // edit a reply to a comment
  static const String EDIT_REPLY = _LOCALHOST_URL + '/comments/edit-reply';

  // delete a reply to a comment
  static const String DELETE_REPLY = _LOCALHOST_URL + '/comments/delete-reply';

  // =================================================================================


  static String fetchMaterialUrlFor({@required String accountType, @required String materialType,}) {
    return _FETCH_MATERIALS + (HelperFucntions.isAcademic(accountType) ? 'uni' : 'sch') + materialType;
  }

  static String getSuitableUrl({String accountType, bool fromCloud = true}) {
    return '$_LOCALHOST_URL' + mainRoutes[accountType];
  }
}
