class Api {
  static final Map<String, String> mainRoutes = {
    'schteachers': '/api/v1/sch-teacher',
    'schstudents': '/api/v1/sch-student',
    'uniteachers': '/api/v1/uni-teacher',
    'unistudents': '/api/v1/uni-student'
  };

  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String LOGOUT_URL = 'https://tranquil-wave-65358.herokuapp.com/api/v1/access/logout';
  static const String LOGIN_URL = 'http://10.0.2.2:3000/api/v1/access/login';//'https://tranquil-wave-65358.herokuapp.com/api/v1/access/login';


  static String getSuitableUrl({String accountType,bool fromCloud = true}) {
    return '$_LOCALHOST_URL' + mainRoutes[accountType];
  }
}
