import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Pages/HomePage.dart';
import 'package:flutter_tracker_application/Pages/Login.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManager.instance.setResizable(false);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageIndexProvider()),
        ChangeNotifierProvider(create: (context) => ActivitiesProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ImgProvider()),
      ],
      child: MaterialApp(
        title: 'T_Tracker',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade900,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = Provider.of<PageIndexProvider>(context).selectedIndex;
    var userProvider = Provider.of<UserProvider>(context);
    var activitiesProvider = Provider.of<ActivitiesProvider>(context);

    Widget page;

    switch (selectedIndex) {
      case 0:
        page = Login();
        break; // Add break statement to prevent fall-through.
      case 1:
        page = HomePage(
          username: userProvider.username,
          password: userProvider.password,
          iv: userProvider.iv,
          activities: activitiesProvider.activities,
        );
        break; // Add break statement to prevent fall-through.
      default:
        page = const Placeholder();
        break; // Add break statement to prevent fall-through.
    }

    return Scaffold(
      body: Container(
        child: page,
      ),
    );
  }
}
