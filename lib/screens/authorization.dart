import 'package:chatbot/screens/login.dart';
import 'package:chatbot/screens/signup.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  @override
  Widget build(BuildContext context) {
    switchPage() {
      showLoginPage = !showLoginPage;
      setState(() {});
    }

    return (showLoginPage)
        ? Login(
            callback: switchPage,
          )
        : SignUp(
            callback: switchPage,
          );
  }
}
