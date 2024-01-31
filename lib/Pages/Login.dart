import 'package:flutter/material.dart'; // Importa tutto da material.dart tranne Key o conflitto con encrypt.dart
import 'package:flutter_tracker_application/Models/UserDataHandler.dart';

class Login extends StatelessWidget {
  final _userNameController = TextEditingController();
  final _userPwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void toLog(String username, String password) {
      _userNameController.clear();
      _userPwdController.clear();
      UserDataHandler.toLog(username, password, context);
    }

    void toReg(String username, String password) async {
      UserDataHandler.toReg(username, password, context);
    }

    final theme = Theme.of(context);
    return Container(
      child: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text("Login",
                      style: theme.textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.primary)),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _userPwdController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                style: TextStyle(fontSize: 10),
                obscureText: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      toReg(_userNameController.text, _userPwdController.text);
                    },
                    child: Text('Register'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      toLog(_userNameController.text, _userPwdController.text);
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
