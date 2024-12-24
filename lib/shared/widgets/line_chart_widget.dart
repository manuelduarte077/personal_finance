import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../features/spending/models/transaction.dart';

class LineChartWidget extends StatelessWidget {
  final List<Transaction> transactions;

  const LineChartWidget({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = [...transactions]
      ..sort((a, b) => a.date.compareTo(b.date));

    double incomeBalance = 0;
    double expenseBalance = 0;

    final incomeSpots = <FlSpot>[];
    final expenseSpots = <FlSpot>[];

    for (var transaction in sortedTransactions) {
      if (transaction.type == TransactionType.income) {
        incomeBalance += transaction.amount;
      } else {
        expenseBalance += transaction.amount;
      }

      incomeSpots.add(FlSpot(
        transaction.date.millisecondsSinceEpoch.toDouble(),
        incomeBalance,
      ));
      expenseSpots.add(FlSpot(
        transaction.date.millisecondsSinceEpoch.toDouble(),
        expenseBalance,
      ));
    }

    return sortedTransactions.isEmpty
        ? const Center(child: Text('No transactions yet'))
        : LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    getTitlesWidget: (value, meta) {
                      final date =
                          DateTime.fromMillisecondsSinceEpoch(value.toInt());

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${date.month}/${date.day}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '\$${value.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                // Income line
                LineChartBarData(
                  spots: incomeSpots,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.green.withValues(alpha: 0.2),
                  ),
                ),
                // Expense line
                LineChartBarData(
                  spots: expenseSpots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.red.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ),
          );
  }
}
