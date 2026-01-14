import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../widgets/input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _authService = AuthService();

  bool loading = false;

  Future<void> _register() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      _show("Please fill all fields");
      return;
    }

    if (_password.text.length < 6) {
      _show("Password must be at least 6 characters");
      return;
    }

    setState(() => loading = true);

    try {
      await _authService.register(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      if (!mounted) return;

      // 🔑 NEW USER → PROFILE SETUP (ONE TIME)
      Navigator.pushReplacementNamed(context, '/profile-setup');
    } on FirebaseAuthException catch (e) {
      _show(e.message ?? "Registration failed");
    } catch (e) {
      _show("Something went wrong. Try again.");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
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
                "Create account ✨",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Start your journey with PathPilot",
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
                  onPressed: loading ? null : _register,
                  child:
                      loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Create Account"),
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
