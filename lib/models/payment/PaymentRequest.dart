class PaymentRequest {
  final String displayId;
  final String boardId; // Added boardId field
  final double amount;
  final List<String>? timeSlots; // List of selected time slots
  final DateTime? date; // The selected date
  final String? transactionId; // Added transactionId field

  PaymentRequest({
    required this.displayId,
    required this.boardId, // Require boardId in the constructor
    required this.amount,
    this.timeSlots,
    this.date,
    this.transactionId, // Optional transactionId
  });

  Map<String, dynamic> toJson() {
    return {
      'displayId': displayId,
      'boardId': boardId, // Include boardId in the request JSON
      'amount': amount,
      'timeSlots': timeSlots, // Include timeSlots in the request JSON
      'date': date?.toIso8601String(), // Include date in ISO8601 format
      'transactionId': transactionId, // Include transactionId in the request JSON
    };
  }
}
