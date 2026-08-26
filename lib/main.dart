import 'package:card_match/features/card_match/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('game_box');

  runApp(const MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
