import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:namer_app/core/constants/constants.dart';
import 'package:namer_app/features/symbols/data/models/symbol_model.dart';

class StockQuoteService {
  final String _baseUrl = '$symbolsApiBaseUrl/v1/quote?token=$apiKey';

  Future<SymbolModel> fetchQuote(String symbol) async {
    if (apiKey.isEmpty) {
      throw Exception('API key is missing. Please provide a valid API key.');
    }
    
    final response = await http.get(Uri.parse('$_baseUrl&symbol=$symbol'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SymbolModel(
        symbol: symbol,
        price: data['c'].toDouble(),
        change: data['dp']?.toDouble(),
      );
    } else {
      throw Exception('Failed to fetch quote for $symbol');
    }
  }

  Future<List<SymbolModel>> fetchQuotes(List<String> symbols) async {
      final quotes = await Future.wait(symbols.map(fetchQuote));
      return quotes;
  }
}
