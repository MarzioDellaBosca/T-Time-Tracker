import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Pages/HomePage.dart';
import 'package:flutter_tracker_application/Pages/Login.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    WindowManager.instance.setResizable(false);
  }

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
        home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: MyHomePage(),
                ),
              ),
            );
          },
        ),
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
      appBar: AppBar(
        title: Text(
          'T Tracker',
          style: TextStyle(color: Colors.white60, fontSize: 25),
        ), // Cambia il titolo qui
        backgroundColor: Colors.blue.shade900, // Cambia il colore qui
      ),
      body: Container(
        child: page,
      ),
    );
  }
}
