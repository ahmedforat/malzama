import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('rebuild the entire page');
    var state = Provider.of<FormTestState>(context, listen: false);
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(25.0),
            child: ListView(children: <Widget>[
            FirstNameWidget(),
            LastNameWidget(),
            EmailWidget(),
            PhoneWidget(),
            PasswordWidget()
            ])));
  }
}

class FormTestState with ChangeNotifier {
  String _firstName, _lastName, _email, _password, _phone;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get phone => _phone;
  String get password => _password;
  String get email => _email;

  void updateFirstName(String update) {
    if (_firstName != update) {
      _firstName = update;
      notifyListeners();
    }
  }

  void updateLastName(String update) {
    if (_lastName != update) {
      _lastName = update;
      notifyListeners();
    }
  }

  void updateEmail(String update) {
    if (_email != update) {
      _email = update;
      notifyListeners();
    }
  }

  void updatePhone(String update) {
    if (_phone != update) {
      _phone = update;
      notifyListeners();
    }
  }

  void updatePassword(String update) {
    if (_password != update) {
      _password = update;
      notifyListeners();
    }
  }
}

class FirstNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FormTestState>(context,listen:false);
    return   Selector<FormTestState, String>(
                  selector: (context, stateProvider) => stateProvider.firstName,
                  builder: (context, firstName, child) {
                    print('rebuilding firstName');
                    return TextField(
                      decoration: InputDecoration(
                        labelText: 'FirstName',
                      ),
                      onChanged: state.updateFirstName,
                    );
                  });
  }
}

class LastNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FormTestState>(context,listen:false);
    return   Selector<FormTestState, String>(
                  selector: (context, stateProvider) => stateProvider.lastName,
                  builder: (context, firstName, child) {
                    print('rebuilding lastName');
                    return TextField(
                      decoration: InputDecoration(
                        labelText: 'LastName',
                      ),
                      onChanged: state.updateLastName,
                    );
                  });
  }
}
class EmailWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FormTestState>(context,listen:false);
    return   Selector<FormTestState, String>(
                  selector: (context, stateProvider) => stateProvider.email,
                  builder: (context, firstName, child) {
                    print('rebuilding email');
                    return TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      onChanged: state.updateEmail,
                    );
                  });
  }
}
class PhoneWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FormTestState>(context,listen:false);
    return   Selector<FormTestState, String>(
                  selector: (context, stateProvider) => stateProvider.phone,
                  builder: (context, phone, child) {
                    print('phone rebuilding');
                    return TextField(
                      decoration: InputDecoration(
                        labelText: 'Phone',
                      ),
                      onChanged: state.updatePhone,
                    );
                  });
  }
}

class PasswordWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<FormTestState>(context,listen:false);
    return   Selector<FormTestState, String>(
                  selector: (context, stateProvider) => stateProvider.password,
                  builder: (context, firstName, child) {
                    print('rebuilding password');
                    return TextField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      onChanged: state.updatePassword,
                    );
                  });
  }
}