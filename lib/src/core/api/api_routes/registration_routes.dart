class RegistrationRoutes{
  /// Basics
  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000/api/v1';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String _LocalServer = 'http://192.168.0.108:3000/api/v1';

  static const String _activeLink = _LOCALHOST_URL;
  ///  signup url
  /// => [ _LOCALHOST_URL + '/registration/signup' ]
  static const String SIGNUP_URL = _activeLink + '/registration/signup';

  /// login url
  ///  => [ _LOCALHOST_URL + '/_activeLink/login' ]
  static const String LOGIN_URL = _activeLink + '/registration/login';

  /// verify email url
  /// => [ _LOCALHOST_URL + '/registration/check-verification' ]
  static const String VERIFY_EMAIL_URL = _activeLink + '/registration/check-verification';

  /// send another verification auth code
  ///  => [ _LOCALHOST_URL + '/registration/send-another-auth-code' ]
  static const String SEND_ANOTHER_AUTH_CODE_URL = _activeLink + '/registration/send-another-auth-code';

// =======================================================================================================================
}