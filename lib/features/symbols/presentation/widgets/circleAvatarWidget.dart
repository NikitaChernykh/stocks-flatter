import 'package:flutter/material.dart';

class CircleRoundAvatar extends StatelessWidget {
  final double size;
  final Color color;
  final String? symbol;
  final bool isLoading;

  const CircleRoundAvatar({
    Key? key,
    this.size = 50.0,
    this.color = Colors.white,
    this.symbol,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: isLoading
          ? CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            )
          : Center(
              child: Text(
                symbol != null && symbol!.isNotEmpty
                    ? symbol![0].toUpperCase() // Get the first letter of the symbol
                    : '',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: size / 2.5, // Adjust the font size relative to the circle size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
