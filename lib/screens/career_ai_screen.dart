import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/ai_service.dart';

class CareerAIScreen extends StatefulWidget {
  const CareerAIScreen({super.key});

  @override
  State<CareerAIScreen> createState() => _CareerAIScreenState();
}

class _CareerAIScreenState extends State<CareerAIScreen> {
  final TextEditingController _questionController = TextEditingController();
  final AIService _aiService = AIService();

  String responseText = "";
  bool loading = false;

  Future<void> _askAI() async {
    if (_questionController.text.trim().isEmpty) return;

    setState(() {
      loading = true;
      responseText = "";
    });

    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('students')
        .doc(user.uid)
        .get();

    final data = doc.data()!;

    final reply = await _aiService.getCareerGuidance(
      name: data['name'],
      branch: data['branch'],
      goal: data['goal'],
      question: _questionController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      responseText = reply;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Career Guidance")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ask PathPilot AI 🤖",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Get personalized career and skill guidance",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              /// INPUT
              TextField(
                controller: _questionController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: "Ask about skills, roadmap, jobs...",
                ),
              ),
              const SizedBox(height: 12),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : _askAI,
                  child: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Ask AI"),
                ),
              ),

              const SizedBox(height: 20),

              /// RESPONSE AREA
              Expanded(
                child: responseText.isEmpty
                    ? const Center(
                        child: Text(
                          "Ask a question to get guidance ✨",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              responseText,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
