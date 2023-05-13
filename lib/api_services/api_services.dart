import 'dart:convert';

import 'package:http/http.dart' as http;

class APIConstants {
  final apiKey = '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';
  final baseUrl = 'https://api.openai.com/v1/chat/completions';
}

class APIServices {
  final _constants = APIConstants();

  fetchResponse(String prompt) async {
    try {
      var APIResponse = await http.post(
        Uri.parse(_constants.baseUrl),
        headers: {
          'Authorization': 'Bearer ${_constants.apiKey}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": prompt}
            ]
          },
        ),
      );

      Map res = jsonDecode(APIResponse.body);
      if (res.containsKey('error')) {
        print('there\'s an error');
        return 'Oops! Looks like we could not generate a response!';
      } else {
        String response = scrapeForMessage(res);
        // print('We got the response: $response');
        return response;
      }
    } catch (e) {
      print('--++>> $e');
      return 'Oops! Looks like we could not generate a response!';
    }
  }

  String scrapeForMessage(Map APIResponse) {
    String response = APIResponse['choices'][0]['message']['content'];
    return response;
  }
}
