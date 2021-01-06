class ProfileRoutes {
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  static const String EDIT_BIO = _LOCALHOST_URL + '/users/edit-bio';
  static const String UPDATE_PERSONAL_INFO = _LOCALHOST_URL + '/users/update-personal-info';
  static const String VERIFY_AND_UPDATE_INFO = _LOCALHOST_URL + '/users/verify-and-update-info';
  static const String DELETE_PICTURE = _LOCALHOST_URL + '/users/delete-picture';
  static const String UPLOAD_PICTURE = _LOCALHOST_URL + '/users/upload-picture';
  static const String DELETE_BIO = _LOCALHOST_URL + '/users/delete-bio';
}
