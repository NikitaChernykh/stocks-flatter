//       Response Example:
//       "p": 7296.89, Last Price
//       "s": "BINANCE:BTCUSDT", Symbol
//       "t": 1575526691134, UNIX milliseconds timestamp
//       "v": 0.011467 Volume

class SymbolModel {
  final String symbol;
  final double price;
  final double? change;

  SymbolModel({
    required this.symbol,
    required this.price,
    this.change,
  });

  factory SymbolModel.fromJson(Map<String, dynamic> json) {
      return SymbolModel(
        symbol: json['s'] ?? '',
        price: json['p']?.toDouble() ?? 0.0,
        change: json['dp']?.toDouble(),
      );
  }
}

