import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {

  Future<String>getData() async {
    String word;
    String apiKey = 'XXXXXXXXXXXXXXXXXXXXXXXXXX';

    http.Response response = await http
        .get('https://wordsapiv1.p.rapidapi.com/words/?random=true', headers: {
      'x-rapidapi-key': '$apiKey',
      'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com'
    });

    if (response.statusCode == 200) {
      String data = response.body;
      word = jsonDecode(data)['word'];
      print(word);
    } else {
      print(response.statusCode);
    }
    return word;
  }
}

class NetworkHelper {
  final String url;
  final Map<String, String> header;
  NetworkHelper({this.url, this.header});

  Future getData() async {
    http.Response response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
