class Api {
  static final Map<String, String> mainRoutes = {
    'schTeacher': '/api/v1/sch-teacher',
    'schStudent': '/api/v1/sch-student',
    'uniTeacher': '/api/v1/uni-teacher',
    'uniStudent': '/api/v1/uni-student'
  };

  static const String _LOCALHOST_URL = 'http://10.0.2.2:3000';
  static const String _CLOUD_URL = 'https://tranquil-wave-65358.herokuapp.com';
  static const String LOGOUT_URL = 'https://tranquil-wave-65358.herokuapp.com/api/v1/access/logout';
  static const String LOGIN_URL = 'https://tranquil-wave-65358.herokuapp.com/api/v1/access/login';


  static String getSuitableUrl({String accountType,bool fromCloud = true}) {
    String path;
    switch (accountType) {
      case 'AccountType.COLLEGE_LECTURER':
        path = Api.mainRoutes['uniTeacher'];
        break;
      case 'AccountType.COLLEGE_STUDENT':
        path = Api.mainRoutes['uniStudent'];
        break;
      case 'AccountType.SCHOOL_TEACHER':
        path = Api.mainRoutes['schTeacher'];
        break;
      case 'AccountType.SCHOOL_STUDENT':
        path = Api.mainRoutes['schStudent'];
        break;
      default:
        break;
    }
    return '${fromCloud ? _CLOUD_URL : _LOCALHOST_URL}' + path;
  }
}
