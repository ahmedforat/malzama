

class CommentsRoutes{

  /// Basics
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  static const String _activeLink = _LOCALHOST_URL;
  // Comments UseCases

  /// fetch comments by ids => ['/comments/fetch-comments']
  static const String FETCH_COMMENTS_BY_IDS = _activeLink + '/comments/fetch-comments';

  /// upload comment => ['/comments/new-comment']
  static const String UPLOAD_COMMENT = _activeLink + '/comments/new-comment';

  /// upload comment => ['/comments/edit-comment']
  static const String EDIT_COMMENT = _activeLink + '/comments/edit-comment';

  /// delete comment => ['/comments/delete-comment']
  static const String DELETE_COMMENT = _activeLink + '/comments/delete-comment';

  /// rate a comment => ['/comments/rate-comment']
  static const String RATE_COMMENT = _activeLink + '/comments/rate-comment';

  // =================================================================================
  /// Replies

  /// upload new reply to a comment => ['/comments/new-reply']
  static const String UPLOAD_NEW_REPLY = _activeLink + '/comments/new-reply';

  /// edit a reply to a comment => ['/comments/edit-reply']
  static const String EDIT_REPLY = _activeLink + '/comments/edit-reply';

  /// delete a reply to a comment => ['/comments/delete-reply']
  static const String DELETE_REPLY = _activeLink + '/comments/delete-reply';

// =================================================================================
}