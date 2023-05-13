import 'dart:async';
import 'package:chatbot/api_services/api_services.dart';
import 'package:chatbot/commons.dart';
import 'package:chatbot/firebase_services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key, required this.email});
  final String email;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final promptController = TextEditingController();
  final _scrollController = ScrollController();

  final api = APIServices();
  final auth = AuthService();
  bool loading = false;

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Store(widget.email);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // APP BAR
      appBar: AppBar(
        title: MyText(
          'ChatGPT Bot',
          weight: FontWeight.bold,
          size: 22,
          spacing: 2,
        ),
      ),

      // DRAWER
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.075,
            screenWidth * 0.2,
            screenWidth * 0.05,
            screenWidth * 0.3,
          ),
          child: Column(
            children: [
              // Logout option
              GestureDetector(
                onTap: () {
                  auth.singOut();
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      'Logout',
                      color: Colors.black,
                      spacing: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Clear History option
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  showConfirmationPopup(context, store,
                      title: 'Are you sure you want to delete all chats?',
                      option: 'clearHistory');
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      'Clear History',
                      color: Colors.black,
                      spacing: 3,
                    ),
                  ],
                ),
              ),

              // Delete Account option
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  showConfirmationPopup(context, store,
                      title:
                          'Are you sure you want to delete your account?\n\nRemember - this is irreversible!',
                      option: 'deleteAccount');
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_off_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    MyText(
                      'Delete Account',
                      color: Colors.black,
                      spacing: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Chat section
            buildChatStream(store, screenHeight),

            // Loading widget
            (loading)
                ? const Center(
                    child: SpinKitThreeBounce(
                      size: 20,
                      color: Colors.white,
                      duration: Duration(seconds: 1),
                    ),
                  )
                : Container(),

            // Text field for prompt
            buildPromptField(store),
          ],
        ),
      ),
    );
  }

  Future showConfirmationPopup(BuildContext context, Store store,
      {required String title, required String option}) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor: Colors.black,
              title: MyText(
                title,
                spacing: 1,
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: MyText(
                      'Cancel',
                      weight: FontWeight.w600,
                      spacing: 2,
                    ),
                  ),

                  // Delete Button
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () async {
                      if (option == 'clearHistory') {
                        await store.clearHistory();
                      } else {
                        await AuthService().deleteAccount();
                        store.deleteUserData();
                      }
                      Navigator.of(context).pop();
                    },
                    child: MyText(
                      'Delete',
                      color: Colors.red,
                      weight: FontWeight.w600,
                      spacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildPromptField(Store store) {
    return GestureDetector(
      onTap: () {
        setState(() {});
        // scrollDownAnimation();
      },
      child: Container(
        color: const Color(0xff1E1D1E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // TextField
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (value) async {
                  String prompt = promptController.text.trim();

                  if (prompt.isNotEmpty) {
                    promptController.clear();
                    store.addAMessage(message: prompt, sender: 'user');

                    loading = true;
                    setState(() {});

                    // Getting response from api
                    String response = await api.fetchResponse(prompt);
                    await store.addAMessage(message: response, sender: 'bot');
                    loading = false;
                    setState(() {});
                  }
                },
                style: const TextStyle(color: Colors.white, letterSpacing: 1),
                controller: promptController,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: InputBorder.none,
                  hintText: 'How may I help you?',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),

            // Submit Button
            IconButton(
              splashRadius: 1,
              onPressed: () async {
                String prompt = promptController.text.trim();
                promptController.clear();

                if (prompt.isNotEmpty) {
                  store.addAMessage(message: prompt, sender: 'user');
                  loading = true;
                  setState(() {});

                  // Getting response from api
                  String response = await api.fetchResponse(prompt);
                  await store.addAMessage(message: response, sender: 'bot');
                  loading = false;
                  setState(() {});
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeOut,
                  );
                });
              },
              icon: const Icon(
                Icons.send,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChatStream(Store store, double screenHeight) {
    return StreamBuilder(
      stream: store.getUserChatData(),
      builder: (context, snapshot) {
        // print(snapshot.data!.data());

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.grey),
          );
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
            );
          });
          List allChats = [];
          Map x = snapshot.data!.data() as Map;
          if (x.containsKey('history')) {
            allChats = x['history'];
          }

          if (allChats.isEmpty) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/bot2.png',
                    height: screenHeight * 0.15,
                    width: screenHeight * 0.15,
                  ),
                  const SizedBox(height: 15),
                  MyText(
                    'Start a Chat!',
                    color: Colors.grey,
                    weight: FontWeight.bold,
                    size: 26,
                    spacing: 4,
                  ),
                ],
              ),
            );
          } else {
            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: allChats.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    chatInfo: allChats[index],
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
