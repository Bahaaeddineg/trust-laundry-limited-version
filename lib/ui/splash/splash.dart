import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../config/routes.dart'; // Import your app routes

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    // Delay the navigation after the animation
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/logo.jpeg",
          height: height / 2.7,
        )
        .animate(
          onComplete: (controller) {
            setState(() {
              _animationCompleted = true;
            });
          }
        )
        .scale(delay: 500.ms, duration: 1500.ms, begin: Offset(1, 1), end: Offset(0.5, 0.5)) // Shrink animation
        .fadeOut(duration: 1500.ms), // Fade out animation
      ),
    );
  }
}
