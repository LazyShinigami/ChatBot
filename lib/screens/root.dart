import 'package:chatbot/firebase_services/services.dart';
import 'package:chatbot/screens/authorization.dart';
import 'package:chatbot/screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return StreamBuilder(
      stream: auth.authChanges,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          User user = snapshot.data!;
          return Homepage(email: user.email!);
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
