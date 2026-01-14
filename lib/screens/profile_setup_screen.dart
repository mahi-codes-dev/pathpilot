import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main_shell.dart';
import '../widgets/input_field.dart';
import '../widgets/primary_button.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _branchController = TextEditingController();
  final _goalController = TextEditingController();

  bool loading = false;

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty ||
        _branchController.text.isEmpty ||
        _goalController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .set({
            'name': _nameController.text.trim(),
            'branch': _branchController.text.trim(),
            'goal': _goalController.text.trim(),
            'profileCompleted': true,
          });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save profile")));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _branchController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Setup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let’s get to know you 👋",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "This helps us personalize your experience",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            InputField(controller: _nameController, label: "Your Name"),
            InputField(controller: _branchController, label: "Branch / Course"),
            InputField(controller: _goalController, label: "Career Goal"),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: PrimaryButton(
                text: loading ? "Saving..." : "Continue",
                onPressed: () {
                  if (!loading) {
                    _saveProfile();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
