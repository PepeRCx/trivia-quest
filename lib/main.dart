import 'package:flutter/material.dart';
import 'package:trivia_quest/pages/auth/delete_account.dart';
import 'package:trivia_quest/pages/bluetooth.dart';
import 'package:trivia_quest/pages/home.dart';
import 'package:trivia_quest/pages/auth/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:trivia_quest/pages/auth/signup.dart';
import 'package:trivia_quest/pages/minigames/ball_sorter.dart';
import 'package:trivia_quest/pages/minigames/ball_sorter_2.dart';
import 'package:trivia_quest/pages/minigames/box_selector.dart';
import 'package:trivia_quest/pages/minigames/classic_snake.dart';
import 'package:trivia_quest/pages/minigames/panda_party.dart';
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

        '/bluetooth': (context) => const BluetoothPage(),
        '/ball_sorter': (context) => const BallSorterPage(),
        '/ball_sorter_2': (context) => const BallSorter2ndPage(),
        '/anagram_sorter': (context) => const BoxSelectorPage(),
        '/panda_party': (context) => const PandaPartyScreen(),
        '/classic_snake': (context) => const SnakeGame(),
      },
    );
  }
}
