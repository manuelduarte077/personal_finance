import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/widgets/balance_card.dart';
import '../../shared/widgets/transaction_list.dart';
import '../spending/bloc/transaction_bloc.dart';
import '../spending/models/transaction.dart';
import 'package:fl_chart/fl_chart.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Wallet'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tarjeta de Balance
                if (state is TransactionLoaded)
                  BalanceCard(
                    title: 'Available Balance',
                    amount: _calculateBalance(state.transactions),
                    subtitle: 'See details',
                  )
                else
                  const BalanceCard(
                    title: 'Available Balance',
                    amount: '\$0',
                    subtitle: 'See details',
                  ),
                const SizedBox(height: 16),

                // Add Chart Section
                if (state is TransactionLoaded) ...[
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: _createChartSections(state.transactions),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Lista de transacciones recientes
                Text(
                  'Recent Transactions',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: state is TransactionLoaded
                      ? TransactionList(transactions: state.transactions)
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _createChartSections(
      List<Transaction> transactions) {
    double totalIncome = 0;
    double totalExpenses = 0;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        totalIncome += transaction.amount;
      } else {
        totalExpenses += transaction.amount;
      }
    }

    return [
      PieChartSectionData(
        value: totalIncome,
        title: 'Income',
        color: Colors.green,
        radius: 50,
      ),
      PieChartSectionData(
        value: totalExpenses,
        title: 'Expenses',
        color: Colors.red,
        radius: 50,
      ),
    ];
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
}
