import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stocks/core/constants/constants.dart';
import 'package:stocks/features/symbols/data/data_sources/remote/stock_quote_service.dart';
import 'package:stocks/features/symbols/data/data_sources/remote/symbol_wss_service.dart';
import 'package:stocks/features/symbols/data/models/symbol_model.dart';
import 'package:stocks/features/symbols/presentation/controllers/home_controller.dart';
import 'package:stocks/features/symbols/presentation/widgets/symbolsViewWidget.dart';
import 'package:stocks/features/symbols/presentation/widgets/pillsViewWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController(WebSocketService(), StockQuoteService());

  List<SymbolModel> allSymbols = [];
  bool _isLoadingStocks = true;
  bool _isLoadingCrypto = true;
  bool _showStocks = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    _setLoading(true);

    _controller.fetchInitialQuotes(
      (stockSymbols) {
        setState(() {
          allSymbols = stockSymbols;
          _isLoadingStocks = false;
        });
      },
      (error) {
        setState(() {
          _hasError = true;
          _errorMessage = error;
        });
      },
    );
  }

  void _setLoading(bool isLoading) {
    setState(() {
      _isLoadingStocks = isLoading;
      _hasError = false;
      _errorMessage = '';
    });
  }

  void handleCryptoSelection() {
     _showStocks = false;
    List<SymbolModel> filteredCryptoSymbols = _controller.filterSymbolsByType(allSymbols, false);
   
    if (filteredCryptoSymbols.isEmpty) {
      setState(() {
        _showStocks = false;
        _isLoadingCrypto = true;
      });

      _controller.subscribeToCrypto((updatedSymbols) {
        setState(() {
          allSymbols = updatedSymbols;
          _isLoadingCrypto = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.disconnectWebSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 120),
          PillsView(
            showStocks: _showStocks,
            onStocksSelected: () {
              setState(() {
                _showStocks = true;
                _controller.subscribeToStocks(); 
              });
            },
            onCryptoSelected: handleCryptoSelection
          ),
          SizedBox(height: 20),
          SymbolsView(
            symbols: _controller.filterSymbolsByType(allSymbols, _showStocks),
            title: _showStocks ? 'Popular Stocks' : 'Popular Cryptocurrencies',
            isLoading: _showStocks ? _isLoadingStocks : _isLoadingCrypto,
            hasError: _hasError,
            errorMessage: _errorMessage,
            onRetry: _initializeData,
          ),
        ],
      ),
    );
  }
}
