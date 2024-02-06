import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Models/UserDataHandler.dart';
import 'package:flutter_tracker_application/Widgets/MarginHandler.dart';
import 'package:flutter_tracker_application/Widgets/MyDropDownButton.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
            height:
                height >= 1002 ? MediaQuery.of(context).size.height / 4 : 230,
            width: width >= 1002 ? MediaQuery.of(context).size.width / 4 : 260,
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
                  MarginHandler(
                    widthRange: 1002,
                    heightRange: 200,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          handleUserChange();
                        },
                        child: Text('Save'),
                      ),
                      SizedBox(height: 5, width: 10),
                      MyDropDownButtor(
                        value: imgPath,
                        hint: 'Change theme',
                        items: <String>[
                          'Img 1',
                          'Img 2',
                          'Img 3',
                          'Img 4',
                          'Img 5',
                          'Img 6',
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            imgPath = newValue!;
                            imgProvider.imgPath =
                                imgPath!.substring(imgPath!.length - 1);
                          });
                        },
                      )
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
