import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/budget_card.dart';
import '../../../shared/widgets/line_chart_widget.dart';
import '../../../shared/widgets/transaction_list.dart';
import '../bloc/transaction_bloc.dart';
import '../models/transaction.dart';

class SpendingScreen extends StatelessWidget {
  const SpendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTransactionModal(context),
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(
            title: const Text('My Spending'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: state is TransactionLoaded
                      ? LineChartWidget(transactions: state.transactions)
                      : const Center(child: CircularProgressIndicator()),
                ),
                const SizedBox(height: 16),
                if (state is TransactionLoaded) ...[
                  BudgetCard(
                    title: 'Balance',
                    amount: _calculateBalance(state.transactions),
                    progress: _calculateProgress(state.transactions),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 3,
                    child: TransactionList(transactions: state.transactions),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _calculateBalance(List<Transaction> transactions) {
    final balance = transactions.fold<double>(
      0,
      (sum, transaction) =>
          sum +
          (transaction.type == TransactionType.income
              ? transaction.amount
              : -transaction.amount),
    );
    return '\$${balance.toStringAsFixed(2)}';
  }

  double _calculateProgress(List<Transaction> transactions) {
    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);
    return income > 0 ? (expenses / income).clamp(0.0, 1.0) : 0.0;
  }

  void _showAddTransactionModal(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    TransactionType selectedType = TransactionType.expense;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Add a new transaction',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<TransactionType>(
                      segments: const [
                        ButtonSegment(
                          value: TransactionType.expense,
                          label: Text('Expense'),
                        ),
                        ButtonSegment(
                          value: TransactionType.income,
                          label: Text('Income'),
                        ),
                      ],
                      selected: {selectedType},
                      onSelectionChanged: (Set<TransactionType> newSelection) {
                        setState(() {
                          selectedType = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            amountController.text.isNotEmpty) {
                          final amount =
                              double.tryParse(amountController.text) ?? 0;
                          context.read<TransactionBloc>().add(
                                AddTransaction(
                                  Transaction(
                                    title: titleController.text,
                                    amount: amount,
                                    type: selectedType,
                                    date: DateTime.now(),
                                  ),
                                ),
                              );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Add transaction'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
