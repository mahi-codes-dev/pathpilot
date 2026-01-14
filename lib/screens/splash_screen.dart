import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scale = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // 🔑 AFTER animation, decide where to go
    Future.delayed(const Duration(milliseconds: 2500), _navigateNext);
  }

  Future<void> _navigateNext() async {
    final user = FirebaseAuth.instance.currentUser;

    // 1️⃣ Not logged in → Login
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // 2️⃣ Logged in → check profile
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .get();

    // Profile NOT completed → Profile Setup
    if (!doc.exists || doc.data()?['profileCompleted'] != true) {
      Navigator.pushReplacementNamed(context, '/profile-setup');
    } else {
      // Profile completed → Main App
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.explore_rounded,
                  size: 96,
                  color: Color(0xFF4F46E5),
                ),
                SizedBox(height: 20),
                Text(
                  "PathPilot",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your guide for study & career clarity",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
