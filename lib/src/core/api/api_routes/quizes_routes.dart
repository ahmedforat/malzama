class QuizRoutes{
  /// Basics
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  static const String _activeLink = _LOCALHOST_URL;

  // quizes usecases

  /// fetch headers of quizes i.e (quizes without questions just credentials) => ['/materials/quizes/fetch-quizes-headers']
  static const String FETCH_QUIZES_HEADERS = _activeLink + '/materials/quizes/fetch-quizes-headers';

  /// fetch quizes headers on refresh => ['/fetch-quizes-headers-on-refresh']
  static const String FETCH_QUIZES_HEADERS_ON_REFRESH = _activeLink + '/materials/quizes/fetch-quizes-headers-on-refresh';

  /// fetch saved quizes headers => ["/fetch-saved-quizes-headers"]
  static const String FETCH_SAVED_QUIZES_HEADERS = _activeLink + '/materials/quizes/fetch-saved-quizes-headers';

  /// fetch quiz questions in pagination style => ['/materials/quizes/fetch-quiz-questions']
  static const String FETCH_QUIZES_QUESTIONS = _activeLink + '/materials/quizes/fetch-quiz-questions';


  /// fetch quiz questions in pagination style => ['/materials/quizes/fetch-all-questions']
  static const String FETCH_ALL_QUESTIONS = _activeLink + '/materials/quizes/fetch-all-questions';

  ///  fetch total quizes count => ['/materials/quizes/fetch-quizes-count']
  static const String FETCH_QUIZES_COUNT = _activeLink + '/materials/quizes/fetch-quizes-count';

  /// edit single quiz item or question => ['/materials/quizes/edit-quiz-item']
  static const String EDIT_QUIZ_ITEM = _activeLink + '/materials/quizes/edit-quiz-item';

  /// delete single quiz item or question => ['/materials/quizes/delete-quiz-item']
  static const String DELETE_QUIZ_ITEM = _activeLink + '/materials/quizes/delete-quiz-item';

  /// fetch single quiz collection => ['/materials/quizes/fetchById']
  static const String FETCH_QUIZ_BY_ID = _activeLink + '/materials/quizes/fetchById';

  /// edit entire quiz  => ['/edit-entire-quiz']
  static const String EDIT_ENTIRE_QUIZ = _activeLink +  '/materials/quizes/edit-entire-quiz';

// ========================================================================================================================
}