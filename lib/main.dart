import 'package:chatbot/screens/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff1E1D1E),
          centerTitle: true,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 86, 84, 86),
      ),
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}
