import 'package:flutter/material.dart';
import 'package:namer_app/features/symbols/data/models/symbol_model.dart';
import 'package:namer_app/features/symbols/presentation/widgets/circleAvatarWidget.dart';
import 'package:namer_app/features/symbols/presentation/widgets/errorViewWidget.dart';

class SymbolsView extends StatelessWidget {
  final List<SymbolModel> symbols;
  final String title;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;

  SymbolsView({
    required this.symbols,
    required this.title,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,  // Fixed height for the SymbolsView
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: hasError
                ? Center(
                    child: ErrorView(
                      errorMessage: errorMessage,
                      onRetry: onRetry,
                    ),
                  )
                : isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        itemCount: symbols.length,
                        separatorBuilder: (context, index) => SizedBox(width: 25),
                        itemBuilder: (context, index) {
                          final String symbol = symbols[index].symbol.split(':').last;
                          final price = symbols[index].price.toString();
                          final double? change = symbols[index].change;
                          final String? changeText = change != null ? "${change.toStringAsFixed(2)}%" : null;
                          return Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                CircleRoundAvatar(
                                  symbol: symbol,
                                  isLoading: false,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  symbol,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  price,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                if (change != null)
                                  Text(
                                    changeText!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: change >= 0 ? Colors.green : Colors.red, 
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
