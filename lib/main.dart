import 'package:flutter/material.dart';
import 'package:trivia_quest/pages/auth/delete_account.dart';
import 'package:trivia_quest/pages/home.dart';
import 'package:trivia_quest/pages/auth/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:trivia_quest/pages/auth/signup.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/delete_account': (context) => const DeleteAccountPage(),
      },
    );
  }
}
