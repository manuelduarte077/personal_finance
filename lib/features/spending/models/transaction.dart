enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  }) : id = id ?? DateTime.now().toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
      ),
      date: DateTime.parse(map['date']),
    );
  }
}
