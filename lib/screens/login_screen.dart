import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authService = AuthService();

  bool loading = false;
Future<void> _login() async {
  if (_email.text.isEmpty || _password.text.isEmpty) {
    _show("Please fill all fields");
    return;
  }

  setState(() => loading = true);

  try {
    await _authService.login(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );

    if (!mounted) return;

    // Splash logic will handle routing
    Navigator.pushReplacementNamed(context, '/');
  } on FirebaseAuthException catch (e) {
    _show(e.message ?? "Login failed");
  } finally {
    if (mounted) setState(() => loading = false);
  }
}

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Welcome back 👋",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Login to continue",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              InputField(
                controller: _email,
                label: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              InputField(
                controller: _password,
                label: "Password",
                isPassword: true,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: loading ? null : _login,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Login"),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/register'),
                child: const Text("Create a new account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
