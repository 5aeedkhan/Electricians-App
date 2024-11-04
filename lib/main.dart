import 'package:electriciansapp/Constants/constants.dart';
import 'package:electriciansapp/Screens/role_selection_screen.dart';
import 'package:electriciansapp/firebase_options.dart';
import 'package:electriciansapp/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: kAppbarColor),
      ),
      home: SplashScreen(),
    );
  }
}
