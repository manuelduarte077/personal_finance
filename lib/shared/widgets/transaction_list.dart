import 'package:flutter/material.dart';
import '../../features/spending/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          title: Text(transaction.title),
          subtitle: Text(transaction.date.toString()),
          trailing: Text(
            '${transaction.type == TransactionType.expense ? "-" : "+"}\$${transaction.amount}',
            style: TextStyle(
              color: transaction.type == TransactionType.expense
                  ? Colors.red
                  : Colors.green,
            ),
          ),
        );
      },
    );
  }
}
