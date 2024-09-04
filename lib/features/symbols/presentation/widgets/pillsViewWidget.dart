import 'package:flutter/material.dart';

class PillsView extends StatelessWidget {
  final bool showStocks;
  final VoidCallback onStocksSelected;
  final VoidCallback onCryptoSelected;

  const PillsView({
    Key? key,
    required this.showStocks,
    required this.onStocksSelected,
    required this.onCryptoSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: onStocksSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: showStocks ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: Text('Stocks'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: onCryptoSelected,
            style: ElevatedButton.styleFrom(
              backgroundColor: !showStocks ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
            ),
            child: Text('Crypto'),
          ),
        ],
      ),
    );
  }
}
