import 'package:flutter/material.dart';
import 'core/vindora_theme.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VindoraCustomerApp());
}

class VindoraCustomerApp extends StatelessWidget {
  const VindoraCustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vindora',
      debugShowCheckedModeBanner: false,
      theme: VindoraTheme.light,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      home: const LoginScreen(),
    );
  }
}