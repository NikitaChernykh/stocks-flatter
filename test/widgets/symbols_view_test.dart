import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stocks/features/symbols/data/models/symbol_model.dart';
import 'package:stocks/features/symbols/presentation/widgets/circleAvatarWidget.dart';
import 'package:stocks/features/symbols/presentation/widgets/symbolsViewWidget.dart';

void main() {
  group('SymbolsView Widget Tests', () {
    testWidgets('displays loading spinner when isLoading is true', (WidgetTester tester) async {
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolsView(
              symbols: [],
              title: 'Popular Symbols',
              isLoading: true,
              hasError: false,
              errorMessage: '',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Popular Symbols'), findsOneWidget);
    });

    testWidgets('displays error message and retry button when hasError is true', (WidgetTester tester) async {
      final String errorMessage = 'Failed to load data.';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolsView(
              symbols: [],
              title: 'Popular Symbols',
              isLoading: false,
              hasError: true,
              errorMessage: errorMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays list of symbols when isLoading is false and hasError is false', (WidgetTester tester) async {
      
      final List<SymbolModel> symbols = [
        SymbolModel(symbol: 'AAPL', price: 150.0, change: 1.5),
        SymbolModel(symbol: 'NVDA', price: 200.0, change: -2.0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolsView(
              symbols: symbols,
              title: 'Popular Symbols',
              isLoading: false,
              hasError: false,
              errorMessage: '',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('AAPL'), findsOneWidget);
      expect(find.text('NVDA'), findsOneWidget);
      expect(find.text('150.0'), findsOneWidget);
      expect(find.text('200.0'), findsOneWidget);
      expect(find.byType(CircleRoundAvatar), findsNWidgets(2));
    });

    testWidgets('displays price change in green when positive and red when negative', (WidgetTester tester) async {
      final List<SymbolModel> symbols = [
        SymbolModel(symbol: 'AAPL', price: 150.0, change: 1.5),
        SymbolModel(symbol: 'NVDA', price: 200.0, change: -2.0),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SymbolsView(
              symbols: symbols,
              title: 'Popular Symbols',
              isLoading: false,
              hasError: false,
              errorMessage: '',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('1.50%'), findsOneWidget);
      expect(find.text('-2.00%'), findsOneWidget);

      final positiveChangeText = tester.widget<Text>(find.text('1.50%'));
      final negativeChangeText = tester.widget<Text>(find.text('-2.00%'));

      expect(positiveChangeText.style?.color, Colors.green);
      expect(negativeChangeText.style?.color, Colors.red);
    });
  });
}
