import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/expense_repository.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  final _repo = ExpenseRepository();
  final _user = FirebaseAuth.instance.currentUser!;
  bool adding = false;

  late Future<List<Map<String, dynamic>>> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    _expensesFuture = _repo.getExpenses(_user.uid);
  }

  Future<void> _addExpense() async {
    if (_title.text.isEmpty || _amount.text.isEmpty || adding) return;

    setState(() => adding = true);

    await _repo.addExpense(
      uid: _user.uid,
      title: _title.text.trim(),
      amount: double.tryParse(_amount.text.trim()) ?? 0,
    );

    _title.clear();
    _amount.clear();
    _loadExpenses();

    setState(() => adding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finance Tracker")),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _title,
                    decoration:
                        const InputDecoration(labelText: "Expense title"),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Amount (₹)"),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: adding ? null : _addExpense,
                      child: adding
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Add Expense"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _expensesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final expenses = snapshot.data!;

                  if (expenses.isEmpty) {
                    return const Center(
                      child: Text(
                        "No expenses yet 💸\nStart tracking your spending",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  double total = 0;
                  for (var e in expenses) {
                    total += (e['amount'] as num).toDouble();
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total Spent"),
                                Text(
                                  "₹${total.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.currency_rupee),
                                title: Text(expenses[index]['title']),
                                trailing: Text(
                                  "₹${(expenses[index]['amount'] as num).toStringAsFixed(2)}",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
