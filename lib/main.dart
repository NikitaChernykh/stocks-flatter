import 'package:flutter/material.dart';
import 'package:namer_app/features/symbols/presentation/pages/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocks App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
