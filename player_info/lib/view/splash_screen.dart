import 'package:flutter/material.dart';
import 'package:player_info/view/login_screen.dart';
import 'package:player_info/view/player_data_screen.dart';
import 'package:player_info/view/session_data.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void navigateTo(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        await SessionData.getSessionData();
        if (SessionData.isLogin!) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PlayerDataScreen(),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    navigateTo(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}
