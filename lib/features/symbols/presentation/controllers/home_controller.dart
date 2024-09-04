import 'package:namer_app/core/constants/constants.dart';
import 'package:namer_app/features/symbols/data/data_sources/remote/stock_quote_service.dart';
import 'package:namer_app/features/symbols/data/data_sources/remote/symbol_wss_service.dart';
import 'package:namer_app/features/symbols/data/models/symbol_model.dart';

class HomeController {
  final WebSocketService _webSocketService;
  final StockQuoteService _stockQuoteService;
  final List<String> stockSymbols = [AAPL, NVDA, MSFT, INTC, TSLA];
  final List<String> cryptoSymbols = [BTCUSDT, ETHBTC, BNBBTC, LTCBTC];

  List<SymbolModel> allSymbols = [];
  bool _isWebSocketConnected = false;

  HomeController(this._webSocketService, this._stockQuoteService);

  Future<void> fetchInitialQuotes(Function(List<SymbolModel>) onSuccess, Function(dynamic) onError) async {
    try {
      final fetchedSymbols = await _stockQuoteService.fetchQuotes(stockSymbols);
      allSymbols = fetchedSymbols;
      onSuccess(fetchedSymbols);
      connectWebSocket(onSuccess);
    } catch (e) {
      onError(e);
    }
  }

  void connectWebSocket(Function(List<SymbolModel>) onSymbolsUpdated) {
    if (!_isWebSocketConnected) {
      _webSocketService.connect();
      _isWebSocketConnected = true;
      _webSocketService.symbolsStream.listen((newSymbols) {
        updateSymbols(newSymbols);
        onSymbolsUpdated(allSymbols);
      });
      
      subscribeToStocks();
    }
  }

  void updateSymbols(List<SymbolModel> newSymbols) {
    for (var updatedSymbol in newSymbols) {
      final index = allSymbols.indexWhere((s) => s.symbol == updatedSymbol.symbol);
      if (index != -1) {
        allSymbols[index] = SymbolModel(
          symbol: allSymbols[index].symbol,
          price: updatedSymbol.price,
          change: isStockSymbol(allSymbols[index].symbol)
              ? allSymbols[index].change
              : null,
        );
      } else if (!isStockSymbol(updatedSymbol.symbol)) {
        allSymbols.add(updatedSymbol);
      }
    }
  }

  void subscribeToStocks() {
    for (var symbol in stockSymbols) {
      _webSocketService.subscribe(symbol);
    }
  }

  void subscribeToCrypto(Function(List<SymbolModel>) onSymbolsUpdated) {
    for (var symbol in cryptoSymbols) {
      _webSocketService.subscribe(symbol);
    }

    _webSocketService.symbolsStream.listen((newSymbols) {
      updateSymbols(newSymbols);
      onSymbolsUpdated(allSymbols);
    });
  }

  void disconnectWebSocket() {
    _webSocketService.disconnect();
  }

  bool isStockSymbol(String symbol) {
    return stockSymbols.contains(symbol);
  }

  List<SymbolModel> filterSymbolsByType(List<SymbolModel> allSymbols, bool isStock) {
    return isStock
        ? allSymbols.where((symbol) => isStockSymbol(symbol.symbol)).toList()
        : allSymbols.where((symbol) => !isStockSymbol(symbol.symbol)).toList();
  }
}
