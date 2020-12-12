class VideoAndPDFRoutes{
  /// Basics
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  static const String _activeLink = _LOCALHOST_URL;
  // [Videos and PDFs]

  // fetch by id
  /// fetch single video or lecture by id => [/materials/videos-and-pdfs/fetchById]
  static const String FETCH_VIDEO_OR_PDF_BY_ID = _activeLink + '/materials/videos-and-pdfs/fetchById';

  // fetch for Pagination
  /// fetch videos or lectures in pagination style => [/materials/videos-and-pdfs/fetch]
  static const String FETCH_VIDEOS_OR_PDFS = _activeLink + '/materials/videos-and-pdfs/fetch';

  /// fetch saved videos or pdfs => ['/fetch-saved-materials']
  static const String FETCH_SAVED_VIDEOS_OR_PDFS = _activeLink + '/materials/videos-and-pdfs/fetch-saved-materials';

  /// fetch videos or pdfs on refresh => ['/fetch-materials-on-refresh']
  static const String FETCH_MATERIALS_ON_REFRESH = _activeLink + '/materials/videos-and-pdfs/fetch-materials-on-refresh';

// ==========================================================================================================================
}