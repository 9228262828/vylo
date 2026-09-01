import 'dart:async';
import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  final ProgressService progress;
  const SplashScreen({super.key, required this.progress});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _go();
  }

  Future<void> _go() async {
    await Future.wait([
      Future.delayed(const Duration(milliseconds: 1300)),
      _waitReady(),
    ]);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen(progress: widget.progress)),
    );
  }

  Future<void> _waitReady() async {
    while (!widget.progress.ready) {
      await Future.delayed(const Duration(milliseconds: 40));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070914),
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF00E7FF),
                      Color(0xFF9B5CFF),
                      Color(0xFFFF7A1A),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x5500E7FF),
                      blurRadius: 34,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.rotate_right_rounded,
                  size: 58,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'VYLO',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 9,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'MATCH  •  SPIN  •  SURVIVE',
                style: TextStyle(
                  color: Color(0xFF00E7FF),
                  fontSize: 10,
                  letterSpacing: 2.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
