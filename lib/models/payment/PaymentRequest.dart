class PaymentRequest {
  final String displayId;
  final String boardId; // Added boardId field
  final double amount;
  final List<String>? timeSlots; // List of selected time slots
  final DateTime? date; // The selected date
  final String? transactionID; // Added transactionId field

  PaymentRequest({
    required this.displayId,
    required this.boardId, // Require boardId in the constructor
    required this.amount,
    this.timeSlots,
    this.date,
    this.transactionID, // Optional transactionId
  });

  Map<String, dynamic> toJson() {
    return {
      'displayId': displayId,
      'boardId': boardId, // Include boardId in the request JSON
      'amount': amount,
      'timeSlots': timeSlots, // Include timeSlots in the request JSON
      'date': date?.toIso8601String(), // Include date in ISO8601 format
      'transactionID': transactionID, // Include transactionId in the request JSON
    };
  }

  // Adding the copyWith method
  PaymentRequest copyWith({
    String? displayId,
    String? boardId,
    double? amount,
    List<String>? timeSlots,
    DateTime? date,
    String? transactionID,
  }) {
    return PaymentRequest(
      displayId: displayId ?? this.displayId,
      boardId: boardId ?? this.boardId,
      amount: amount ?? this.amount,
      timeSlots: timeSlots ?? this.timeSlots,
      date: date ?? this.date,
      transactionID: transactionID ?? this.transactionID,
    );
  }
}
