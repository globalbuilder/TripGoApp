import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  final String _baseUrl = "https://open.er-api.com/v6/latest/USD";

  Future<Map<String, dynamic>> fetchExchangeRates() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] == 'success') {
        return data['rates'] as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch exchange rates: ${data['error-type']}');
      }
    } else {
      throw Exception('Failed to fetch exchange rates');
    }
  }
}
