import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  String content;
  Color? color;
  double? size;
  double? spacing, wordSpacing;
  List<Shadow>? shadowList;
  FontWeight? weight;

  MyText(
    this.content, {
    super.key,
    this.color,
    this.size,
    this.spacing,
    this.wordSpacing,
    this.shadowList,
    this.weight,
  }) {
    color ??= Colors.white;
    size ??= 16;
    spacing ??= 0;
    wordSpacing ??= 0;
    shadowList ??= [];
    weight ??= FontWeight.normal;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: TextStyle(
        color: color,
        fontSize: size,
        letterSpacing: spacing,
        wordSpacing: wordSpacing,
        shadows: shadowList,
        fontWeight: weight,
      ),
    );
  }
}

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key, required this.chatInfo});
  final Map chatInfo;

  @override
  Widget build(BuildContext context) {
    String imgUrl;
    Color chatColor;
    if (chatInfo['sender'] == 'bot') {
      imgUrl = 'assets/bot2.png';
      chatColor = const Color.fromARGB(255, 54, 52, 54);
    } else {
      imgUrl = 'assets/person.png';
      chatColor = const Color.fromARGB(31, 0, 0, 0);
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
      color: chatColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User / Bot Logo
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(500),
              image:
                  DecorationImage(image: AssetImage(imgUrl), fit: BoxFit.cover),
            ),
          ),

          // Actual Message
          const SizedBox(width: 15),
          Expanded(child: MyText('${chatInfo['msg']}'))
        ],
      ),
    );
  }
}
