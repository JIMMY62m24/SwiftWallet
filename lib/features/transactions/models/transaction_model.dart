class Transaction {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
    };
  }
}

enum TransactionType { send, receive, deposit, withdraw }

enum TransactionStatus { pending, completed, failed, cancelled }
