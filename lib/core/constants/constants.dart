

import 'package:flutter_dotenv/flutter_dotenv.dart';

const String symbolsWevSocketBaseUrl = 'wss://ws.finnhub.io';
const String symbolsApiBaseUrl = 'https://finnhub.io/api';
String apiKey = dotenv.env['API_KEY'] ?? '';

// Stock Symbols
const String AAPL = 'AAPL';
const String NVDA = 'NVDA';
const String MSFT = 'MSFT';

// Crypto Symbols
const String BTCUSDT = 'BINANCE:BTCUSDT';
const String ETHBTC = 'BINANCE:ETHBTC';
const String BNBBTC = 'BINANCE:BNBBTC';