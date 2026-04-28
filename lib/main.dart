import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/mode_screen.dart';
import 'services/disease_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  final diseaseService = DiseaseService();
  runApp(KcdApp(diseaseService: diseaseService));
}

class KcdApp extends StatelessWidget {
  final DiseaseService diseaseService;

  const KcdApp({super.key, required this.diseaseService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '질병분류기호',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1A73E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          primary: const Color(0xFF1A73E8),
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: SplashScreen(diseaseService: diseaseService),
      routes: {
        '/mode': (context) => ModeScreen(diseaseService: diseaseService),
      },
    );
  }
}
