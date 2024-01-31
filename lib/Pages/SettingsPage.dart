import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Models/UserDataHandler.dart';

class SettingsPage extends StatefulWidget {
  final userProvider;
  final imgProvider;

  SettingsPage({required this.userProvider, required this.imgProvider});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userNameController = TextEditingController();
  final _userPwdController = TextEditingController();
  UserProvider get userProvider => widget.userProvider;
  ImgProvider get imgProvider => widget.imgProvider;
  String? imgPath;

  void handleUserChange() async {
    UserDataHandler.handleUserChange(
        userProvider.username,
        _userNameController.text,
        userProvider.password,
        _userPwdController.text,
        context);
    _userNameController.clear();
    _userPwdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgProvider
              .imgPath), // sostituisci con il tuo percorso di immagine
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Card(
          child: Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 4,
            margin: EdgeInsets.all(10),
            child: FocusScope(
              node: FocusScopeNode(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Change username:',
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _userPwdController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Change password:',
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          handleUserChange();
                        },
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () => {},
                        child: DropdownButton<String>(
                          hint: Text('Change theme',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.w600)),
                          value: imgPath,
                          elevation: 15,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w600),
                          underline: Container(
                            height: 0,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              imgPath = newValue!;
                              imgProvider.imgPath =
                                  imgPath!.substring(imgPath!.length - 1);
                            });
                          },
                          items: <String>[
                            'Img 1',
                            'Img 2',
                            'Img 3',
                            'Img 4',
                            'Img 5',
                            'Img 6',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
