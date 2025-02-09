// payment_response.dart

class PaymentResponse {
  final String transactionId;
  final String status;

  PaymentResponse({required this.transactionId, required this.status});

  // Factory constructor to create a PaymentResponse from JSON
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      transactionId: json['transactionId'],
      status: json['status'],
    );
  }

  // Method to convert PaymentResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'status': status,
    };
  }
}
