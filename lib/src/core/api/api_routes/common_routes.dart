class CommonRoutes{
  /// Basics
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  static const String _activeLink = _LOCALHOST_URL;
  // Common

  /// upload new material videos pdfs or quizes => [ _LOCALHOST_URL + '/materials/common/new' ]
  static const String UPLOAD_NEW_MATERIAL = _activeLink + '/materials/common/new';

  ///  delete entire material pdf or video or even entire quiz collection => ['/materials/common/delete']
  static const String DELETE_MATERIAL = _activeLink + '/materials/common/delete';

  /// edit a material video or pdf or entire quiz =>  ['/materials/common/edit']
  static const String EDIT_MATERIAL = _activeLink + '/materials/common/edit';

  /// add a material to user saved items => ['/materials/common/save']
  static const String MARK_MATERIAL_AS_SAVED = _activeLink + '/materials/common/save';

// ///  fetch materials for videos and lectures only => ['/materials/videos-and-pdfs/fetch-material']
// static const String _FETCH_MATERIALS = _LOCALHOST_URL + '/materials/fetch-material';

// ========================================================================================================================
}