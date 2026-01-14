import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../theme/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance
                .collection('students')
                .doc(_user.uid)
                .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 44,
                    child: Icon(Icons.person, size: 44),
                  ),
                ),
                const SizedBox(height: 16),

                Center(
                  child: Text(
                    data['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    _user.email ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 32),

                _infoTile("Branch / Course", data['branch']),
                _infoTile("Career Goal", data['goal']),

                const SizedBox(height: 24),

                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Edit Profile"),
                  onTap: () {
                    _showEditDialog(data);
                  },
                ),

                const Spacer(),
                Consumer<ThemeController>(
                  builder: (context, theme, _) {
                    return SwitchListTile(
                      secondary: const Icon(Icons.dark_mode),
                      title: const Text("Dark Mode"),
                      value: theme.isDark,
                      onChanged: (_) => theme.toggleTheme(),
                    );
                  },
                ),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> data) {
    final nameCtrl = TextEditingController(text: data['name']);
    final branchCtrl = TextEditingController(text: data['branch']);
    final goalCtrl = TextEditingController(text: data['goal']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: branchCtrl,
                decoration: const InputDecoration(labelText: "Branch"),
              ),
              TextField(
                controller: goalCtrl,
                decoration: const InputDecoration(labelText: "Goal"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('students')
                    .doc(_user.uid)
                    .update({
                      'name': nameCtrl.text.trim(),
                      'branch': branchCtrl.text.trim(),
                      'goal': goalCtrl.text.trim(),
                    });

                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }
}
