import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/analytics_repository.dart';
import '../widgets/analytics_card.dart';

import 'planner_screen.dart';
import 'finance_screen.dart';
import 'career_ai_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _user = FirebaseAuth.instance.currentUser!;
  final _analyticsRepo = AnalyticsRepository();

  Future<List<dynamic>> _loadAnalytics() {
    return Future.wait([
      _analyticsRepo.getWeeklyStudyStreak(_user.uid),
      _analyticsRepo.getWeeklyExpenseTotal(_user.uid),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PathPilot")),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 28),
              _analyticsSection(),
              const SizedBox(height: 32),
              _quickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  // 👋 Header
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Welcome back 👋",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          "Here's your progress snapshot",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  // 📊 Analytics Cards
  Widget _analyticsSection() {
    return FutureBuilder<List<dynamic>>(
      future: _loadAnalytics(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            "Unable to load analytics right now",
            style: TextStyle(color: Colors.redAccent),
          );
        }

        final studyStreak = snapshot.data![0] as int;
        final expenseTotal = snapshot.data![1] as double;

        return Row(
          children: [
            Expanded(
              child: AnalyticsCard(
                title: "Tasks",
                value: "$studyStreak Done",
                subtitle: "Last 7 days",
                icon: Icons.done_all_rounded,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AnalyticsCard(
                title: "Spent",
                value: "₹${expenseTotal.toStringAsFixed(0)}",
                subtitle: "This week",
                icon: Icons.account_balance_wallet,
                color: Colors.orange,
              ),
            ),
          ],
        );
      },
    );
  }

  // 🚀 Quick Actions
  Widget _quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        _actionTile(
          context,
          icon: Icons.check_circle_outline,
          title: "Study Planner",
          subtitle: "Plan & track tasks",
          screen: const PlannerScreen(),
        ),
        _actionTile(
          context,
          icon: Icons.account_balance_wallet,
          title: "Finance Tracker",
          subtitle: "Track expenses",
          screen: const FinanceScreen(),
        ),
        _actionTile(
          context,
          icon: Icons.smart_toy_outlined,
          title: "AI Career Guide",
          subtitle: "Get clarity & advice",
          screen: const CareerAIScreen(),
        ),
      ],
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget screen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.12),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ).then((_) => setState(() {}));
        },
      ),
    );
  }
}
