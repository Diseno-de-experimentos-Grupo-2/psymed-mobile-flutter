import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const PsyMedApp());
}

class PsyMedApp extends StatelessWidget {
  const PsyMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PsyMed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginScreen(),
    );
  }
}