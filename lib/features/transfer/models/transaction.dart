class Transaction {
  final String id;
  final String senderPhone;
  final String recipientPhone;
  final double amount;
  final DateTime timestamp;
  final String status;

  const Transaction({
    required this.id,
    required this.senderPhone,
    required this.recipientPhone,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      senderPhone: json['sender_phone'] as String,
      recipientPhone: json['recipient_phone'] as String,
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender_phone': senderPhone,
        'recipient_phone': recipientPhone,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
        'status': status,
      };
}
