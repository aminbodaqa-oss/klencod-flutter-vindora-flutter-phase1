import 'package:flutter/material.dart';
import '../core/vindora_theme.dart';
import '../services/api_client.dart';
import 'store_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiClient();
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final result = await _api.post('login', {
        'email': _email.text.trim(),
        'password': _password.text,
      });
      final token = result['token']?.toString();
      if (token == null || token.isEmpty) {
        throw ApiException('لم يرجع الخادم رمز الدخول.');
      }
      await _api.saveToken(token);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StoreHomeScreen()),
      );
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('حدث خطأ غير متوقع. حاول مرة أخرى.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 76,
                        width: 76,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: VindoraColors.navy,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Text('V', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w800)),
                      ),
                      const SizedBox(height: 24),
                      const Text('أهلاً بيك في Vindora', style: TextStyle(color: VindoraColors.navy, fontSize: 26, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      const Text('سجّل دخولك عشان تقدر تكمل طلباتك وتتابعها.', style: TextStyle(color: VindoraColors.muted, height: 1.6)),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined)),
                        validator: (v) => v == null || !v.contains('@') ? 'اكتب بريد إلكتروني صحيح' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'اكتب كلمة المرور' : null,
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton(
                        onPressed: _busy ? null : _login,
                        child: _busy
                            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Text('تسجيل الدخول'),
                      ),
                      const SizedBox(height: 14),
                      const Text('إنشاء الحساب واستعادة كلمة المرور سيتم ربطهما بعد تجهيز واجهات التحقق الآمنة في الخادم.', textAlign: TextAlign.center, style: TextStyle(color: VindoraColors.muted, fontSize: 12, height: 1.6)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
