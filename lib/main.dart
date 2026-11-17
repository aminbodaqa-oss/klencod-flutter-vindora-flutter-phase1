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
      home: const VindoraSplashScreen(),
    );
  }
}

class VindoraSplashScreen extends StatefulWidget {
  const VindoraSplashScreen({super.key});

  @override
  State<VindoraSplashScreen> createState() => _VindoraSplashScreenState();
}

class _VindoraSplashScreenState extends State<VindoraSplashScreen> {
  @override
  void initState() {
    super.initState();
    _continueToLogin();
  }

  Future<void> _continueToLogin() async {
    await Future<void>.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, animation, secondaryAnimation) => const LoginScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Vindora',
                style: TextStyle(
                  color: VindoraColors.navy,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: VindoraColors.purple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
