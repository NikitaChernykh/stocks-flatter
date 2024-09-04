import 'package:namer_app/core/constants/constants.dart';
import 'package:namer_app/features/symbols/data/data_sources/remote/stock_quote_service.dart';
import 'package:namer_app/features/symbols/data/data_sources/remote/symbol_wss_service.dart';
import 'package:namer_app/features/symbols/data/models/symbol_model.dart';

class HomeController {
  final WebSocketService _webSocketService;
  final StockQuoteService _stockQuoteService;

  List<SymbolModel> allSymbols = [];
  bool _isWebSocketConnected = false;

  HomeController(this._webSocketService, this._stockQuoteService);

  Future<void> fetchInitialQuotes(Function(List<SymbolModel>) onSuccess, Function(dynamic) onError) async {
    try {
      final stockSymbols = await _stockQuoteService.fetchQuotes([AAPL, NVDA, MSFT]);
      allSymbols = stockSymbols;
      onSuccess(stockSymbols);
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
    _webSocketService.subscribe(AAPL);
    _webSocketService.subscribe(NVDA);
    _webSocketService.subscribe(MSFT);
  }

  void subscribeToCrypto(Function(List<SymbolModel>) onSymbolsUpdated) {
    _webSocketService.subscribe(BTCUSDT);
    _webSocketService.subscribe(ETHBTC);
    _webSocketService.subscribe(BNBBTC);

    _webSocketService.symbolsStream.listen((newSymbols) {
      updateSymbols(newSymbols);
      onSymbolsUpdated(allSymbols);
    });
  }

  void disconnectWebSocket() {
    _webSocketService.disconnect();
  }

  bool isStockSymbol(String symbol) {
    return symbol == AAPL || symbol == NVDA || symbol == MSFT;
  }

  List<SymbolModel> filterSymbolsByType(List<SymbolModel> allSymbols, bool isStock) {
    return isStock
        ? allSymbols.where((symbol) => isStockSymbol(symbol.symbol)).toList()
        : allSymbols.where((symbol) => !isStockSymbol(symbol.symbol)).toList();
  }
}
