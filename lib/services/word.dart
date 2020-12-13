import 'http.dart';

const apiKey = 'e63acca36amshea9c0377e4aa282p12399ajsnae3ecd2058ac';

const wordsURL = 'https://wordsapiv1.p.rapidapi.com/words/?random=true';

class WordModel {
  Future<dynamic> getWord() async {
    NetworkHelper networkHelper = NetworkHelper(
      url :'$wordsURL', header: {
      'x-rapidapi-key': '$apiKey',
      'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com'
    });

    var wordData = await networkHelper.getData();
    return wordData;
  }
}
