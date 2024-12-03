import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:player_info/firebase_options.dart';
import 'package:player_info/player_data_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlayerDataScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
