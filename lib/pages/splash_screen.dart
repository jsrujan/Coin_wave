// ignore_for_file: library_private_types_in_public_api

import 'package:coins_app/pages/home_screen.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      title: const Text(
        "CoinWave",
        style: TextStyle(
            fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.black,
      showLoader: false,
      navigator: const HomeScreen(),
      durationInSeconds: 2,
      logo: Image.asset("assets/logo.png"),
    );
  }
}
