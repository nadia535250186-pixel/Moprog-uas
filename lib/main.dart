import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'pages/quiz/quiz_menu_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinguaLearn',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF58CC02),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7FFF5),
      ),
      home: const QuizMenuPage(),
    );
  }
}
