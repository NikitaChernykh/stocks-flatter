import 'dart:async';
import 'dart:convert';
import 'package:namer_app/core/constants/constants.dart';
import 'package:namer_app/features/symbols/data/models/symbol_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final String _url = '$symbolsWevSocketBaseUrl?token=$apiKey';
  late WebSocketChannel _channel;
  final _symbolsController = StreamController<List<SymbolModel>>.broadcast();
  final Map<String, SymbolModel> _symbols = {};

  Stream<List<SymbolModel>> get symbolsStream => _symbolsController.stream;

  WebSocketService([WebSocketChannel? channel]) {
    if (channel != null) {
      _channel = channel;
    }
  }

  void connect() {
    _channel = WebSocketChannel.connect(Uri.parse(_url));
    print('WebSocket connection established');
    _channel.stream.listen(_handleEvent, onDone: _handleDone, onError: _handleError);
  }

  void _handleEvent(dynamic event) {
    final decodedData = jsonDecode(event);
    if (decodedData['type'] == 'trade') {
      List<dynamic> trades = decodedData['data'];
      for (var trade in trades) {
            final symbolModel = SymbolModel.fromJson(trade);
           if (symbolModel.symbol.isNotEmpty) {
              _symbols[symbolModel.symbol] = symbolModel;
            }
      }
     _symbolsController.add(_symbols.values.toList());
    }
  }

  void _handleDone() {
    print('WebSocket closed');
    _symbolsController.close();
  }

  void _handleError(Object error) {
    print('Error occurred: $error');
    _symbolsController.close();
  }

  void subscribe(String symbol) {
    final request = jsonEncode({'type': 'subscribe', 'symbol': symbol});
    _channel.sink.add(request);
  }

  void unsubscribe(String symbol) {
    final request = jsonEncode({'type': 'unsubscribe', 'symbol': symbol});
    _channel.sink.add(request);
  }

  void disconnect() {
    _channel.sink.close(status.goingAway);
  }
}