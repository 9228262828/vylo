import 'package:flutter/material.dart';
import 'services/progress_service.dart';
import 'screens/splash_screen.dart';

class VyloBootstrap extends StatefulWidget {
  const VyloBootstrap({super.key});

  @override
  State<VyloBootstrap> createState() => _VyloBootstrapState();
}

class _VyloBootstrapState extends State<VyloBootstrap> {
  final ProgressService progress = ProgressService();

  @override
  void initState() {
    super.initState();
    progress.load();
  }

  @override
  void dispose() {
    progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VYLO',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070914),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E7FF),
          secondary: Color(0xFFFF7A1A),
          tertiary: Color(0xFFB8FF39),
          surface: Color(0xFF101426),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.8,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: -1.1,
          ),
          titleLarge: TextStyle(fontWeight: FontWeight.w900),
          titleMedium: TextStyle(fontWeight: FontWeight.w800),
          bodyLarge: TextStyle(height: 1.35),
          bodyMedium: TextStyle(height: 1.35),
        ),
      ),
      home: SplashScreen(progress: progress),
    );
  }
}
