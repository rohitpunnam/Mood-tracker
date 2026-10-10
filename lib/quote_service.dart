
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  Future<String> fetchQuote() async {
    final response = await http
        .get(Uri.parse('https://dummyjson.com/quotes/random'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Could not load quote');
    }

    final data = jsonDecode(response.body);

    return '"${data['quote']}" — ${data['author']}';
  }
}
