
 //  this is the the response manager file for malzama app;
 

abstract class ContractResponse {
  int get statusCode;
  String get message;
}

abstract class Failure implements ContractResponse {}

abstract class Success implements ContractResponse {}

abstract class SnackBarException extends Failure {}

class NewBugException implements Failure {
  NewBugException({int statusCode, String message})
      : _message = message,
        _statusCode = statusCode;

  String _message;

  int _statusCode;

  @override
  String get message => this._message;

  @override
  int get statusCode => this._statusCode;
}

// subclasses of the Success SuperClass
class Success200 implements Success {
  String _message;

  Success200({String message = 'OK'}) : this._message = message;

  @override
  String get message => this._message;

  @override
  int get statusCode => 200;
}

class Success201 implements Success {
  String _message;

  Success201({String message = 'CREATED'}) : this._message = message;

  @override
  String get message => this._message;

  @override
  int get statusCode => 201;
}

//*********************************************************************//

class ServerNotResponding implements SnackBarException {
  ServerNotResponding({String message = 'Server is not responding'})
      : this._message = message;
  String _message;

  @override
  String get message => this._message;

  @override
  int get statusCode => 503;
}

class InternalServerError implements SnackBarException {
  InternalServerError({String message = 'Something went wrong'})
      : this._message = message;

  String _message;

  @override
  String get message => this._message;

  @override
  int get statusCode => 500;
}

class NotAuthorized implements SnackBarException {
  NotAuthorized({String message = 'Not Authorized'}) : this._message = message;

  String _message;

  @override
  String get message => this._message;

  @override
  int get statusCode => 401;
}

class Forbidden implements SnackBarException {
  Forbidden({String message = 'Forbidden'}) : this._message = message;

  String _message;

  @override
  String get message => this._message;

  @override
  int get statusCode => 403;
}

class NoInternetConnection implements SnackBarException {
  @override
  String get message => 'No internet connection';

  @override
  int get statusCode => 0;
}
