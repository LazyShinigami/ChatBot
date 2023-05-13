import 'package:chatbot/commons.dart';
import 'package:chatbot/firebase_services/services.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.callback});
  final VoidCallback callback;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  String errorMessage = '';
  final auth = AuthService();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Login title
          MyText(
            'Login',
            weight: FontWeight.bold,
            size: 32,
            spacing: 2,
          ),

          // Error Message
          (errorMessage.toString() != 'null' || errorMessage.isEmpty)
              ? Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: MyText(
                    errorMessage,
                    color: Colors.red,
                    weight: FontWeight.bold,
                  ),
                )
              : Container(),

          // E-mail Textfield
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color(0xff1E1D1E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: emailController,
              style: const TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your E-mail',
                hintStyle: TextStyle(
                    letterSpacing: 2,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),

          // Password Textfield
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color(0xff1E1D1E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              obscureText: true,
              controller: pwdController,
              style: const TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Your Password',
                hintStyle: TextStyle(
                    letterSpacing: 2,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),

          // Submit Button
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              loading = true;
              setState(() {});

              if (emailController.text.trim().isEmpty ||
                  pwdController.text.isEmpty) {
                errorMessage = "All fields are mandatory!";

                loading = false;
                setState(() {});
              } else {
                errorMessage = await auth.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: pwdController.text);

                if (errorMessage.isNotEmpty) {
                  loading = false;
                  setState(() {});
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 45,
              decoration: BoxDecoration(
                // color: const Color(0xff1E1D1E),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: (loading)
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : MyText(
                        'Submit',
                        weight: FontWeight.w300,
                        spacing: 2,
                        size: 20,
                        color: Colors.black,
                      ),
              ),
            ),
          ),

          // Forgot Password Link
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              // show loading
              if (emailController.text.trim().isEmpty) {
                errorMessage = 'Please enter your registered E-mail!';
                setState(() {});
              } else {
                errorMessage = await auth.resetPassword(
                    email: emailController.text.trim());
                if (errorMessage.isNotEmpty) {
                  setState(() {});
                }
                errorMessage = 'Reset E-mail has been sent!';
                setState(() {});
              }
            },
            child: MyText(
              'Forgot Password?',
              weight: FontWeight.w500,
              spacing: 2,
            ),
          ),

          // Sign up Link
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                'New here? ',
                spacing: 2,
              ),
              GestureDetector(
                onTap: widget.callback,
                child: MyText(
                  'Sign Up!',
                  weight: FontWeight.w500,
                  spacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
